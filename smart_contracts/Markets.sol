// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./helper_contracts/Maths.sol";
import "./chainlink_contracts/PriceFeeder.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


contract Markets is KeeperCompatibleInterface{

    using MathContract for *;
    // deposit event
    event Deposited(
        //address of the player
        address player,
        //market id
        bytes32 marketId,
        //shares bought
        uint256[2] sharesBought,
        //money waged
        uint256[2] moneyWaged
    );

    // withdraw event
    event Withdrawed(
        //player
        address player,
        //market
        bytes32 marketId,
        //amount of money withdrawed
        uint256 moneyWithdrawed,
        //player's expert score
        uint256 expertScore
    );

    // market created event
    event MarketCreated(
        //market
        bytes32 marketId
    );

    event MarketResolved(
        //market
        bytes32 marketId
    );

    //player struct
    struct Player{
        uint256[2] moneyWaged;
        uint256[2] sharesOwned;
        uint256 reward;
        uint256 expertScore;
        bool withdrawed;
    }


    // market struct
    struct Market{
        //mapping(address => player) players of the market
        mapping(address => Player) players;
        //total amount of shares owned for each outcome
        uint256[2] sharesOwned;
        //total amount of money waged for each outcome
        uint256[2] moneyWaged;
        //the asset name
        address priceFeedAddress;
        //value to compare the price of the asset with to determine the outcome
        uint256 benchPrice;
        //Resolution date
        uint256 resolutionDate;
        // The last date to wage money on a bet
        uint256 wageDeadline;
        //winning outcome
        uint256 winningOutcome;
        //resolved flag
        bool resolved;
    }

    // multiplier used in computations
    uint256 constant MULTIPLIER = 1000000000000000000;
    //alpha hyperparamter used in price function
    uint256 constant ALPHA = 15;
    //the maximum amount of markets that can be resolved within one block
    uint256 constant MAX_MARKETS_UPDATE = 30;

    //payToken
    IERC20 payToken;
    //linkToken
    IERC20 linkToken;
    //price feeder contract
    PriceConsumer priceConsumer;

    //the amount of markets created
    uint256 public numMarkets;

    //mapping to store all the bets. The bet is identified by its betId
    mapping(bytes32 => Market) public markets;

    //initialize pay and link stoken
    constructor(
        address payesTokenAddress,
        address linkTokenAddress,
        address priceConsumerAddress,
    ) public {
        payToken = IERC20(payesTokenAddress);
        linkToken = IERC20(linkTokenAddress);
        priceConsumer = PriceFeeder(priceConsumerAddress);
    }

    //function to create a bet
    function createMarket(
        uint256[2] memory _sharesOwned,
        uint256[2] memory _moneyWaged,
        address _priceFeedAddress,
        uint256 _benchPrice,
        uint256 _resolutionDate,
        uint256 _wageDeadline,
    ) external {

        //checking date conditions
        require(
            block.timestamp < _resolutionDate,
            "resolution date has passed"
        );
        require(
            block.timestamp < _wageDeadline,
            "wagedeadline has passed"
        );
        require(
            _wageDeadline < _resolutionDate,
            "resolution happens after last wage"
        );

        //check money waged condition
        _validateMoneyWaged(_moneyWaged);

        //check shares owned condition
        _validateSharesOwned(_sharesOwned);

        //initialize the market
        Market storage market = markets[numMarkets];

        //initialize the player (one who creates a market is the first player
        {
            Player memory _player;
            _player.sharesOwned = _sharesOwned;
            _player.moneyWaged = _moneyWaged;
            //add player to market players
            market.players[msg.sender] = _player;
        }

        //assign shares owned
        market.sharesOwned = _sharesOwned;
        //assign money waged
        market.moneyWaged = _moneyWaged;
        //assign price feed address
        market.priceFeedAddress = _priceFeedAddress;
        //assign bench price
        market.benchPrice = _benchPrice;
        // assign resolution date
        market.resolutionDate = _resolutionDate;
        // assign wage  deadline
        market.wageDeadline = _wageDeadline;
        //increment the num markets by 1
        numMarkets += 1;

        //emit event that market is created
        emit MarketCreated(numMarkets);

        //emit event that the money was deposited
        emit Deposited(
            msg.sender,
            numMarkets,
            _moneyWaged,
            _sharesOwned
        );

    }

    //waging money on a market
    function wageMoney(
        uint256 marketId,
        uint256[2] memory _sharesToPurchase
    ) external {

        //check that wage deadline is not passed
        require(markets[marketId].wageDeadline > block.timestamp);

        //array to store the amount to be waged by a player on each outcome
        uint256[2] memory _moneyToWage;

        //total to be waged amount
        uint256 _transferAmount;

        for(uint256 i = 0; i < _sharesToPurchase.length; i++){
            _moneyToWage[i] += _priceBuyShares(
                marketId,
                i,
                _sharesToPurchase[i]
            );
        }

        _transferAmount = _moneyToWage.sumArr();

        //check tha the player has sufficient funds
        require(
            markets[marketId].payToken.balanceOf(msg.sender) >= _transferAmount
        );

        //transfer funds
        markets[marketId].payToken.transferFrom(
            msg.sender,
            address(this),
            _transferAmount
        );

        //update moneyWage and sharesOwned both for market and for a player
        for(uint256 i; i <  _sharesToPurchase.length; i++){

            markets[marketId].sharesOwned[i] += _sharesToPurchase[i];
            markets[marketId].moneyWaged[i] += _moneyToWage[i];

            (
                markets
                [marketId]
                .players
                [msg.sender]
                .sharesOwned
                [i]
            ) += _sharesToPurchase[i];

            (
                markets
                [marketId]
                .players
                [msg.sender]
                .moneyWaged
                [i]
            ) += _moneyToWage[i];

        }

        // emit deposit events
        emit Deposited(msg.sender, marketId, _sharesToPurchase, _moneyToWage);
    }

    //withdrawing money from a market
    function withdraw(bytes32 marketId) external {

        //check that market is resolved
        require(markets[marketId].resolved);
        /*
            check that the player had not previously
            withdrawed money from this market
        */
        require(!markets[marketId].players[msg.sender].withdrawed);

        //calculate reward
        uint256 _rewardAmount = calcReward(marketId, msg.sender);
        //calculate expert score
        uint256 _expertScore = calcExpertScore(marketId, msg.sender);

        //reward the player
        markets[marketId].payToken.transfer(msg.sender, _rewardAmount);

        //update the player's reward data
        (
            markets
            [marketId]
            .players
            [msg.sender]
            .reward
        ) = calcReward(marketId, msg.sender);

        //update the player's expert score data
        (
            markets
            [marketId]
            .players
            [msg.sender]
            .expertScore
        ) = calcExpertScore(marketId, msg.sender);

        //update the player's withdrawed flag
        (
            markets
            [marketId]
            .players
            [msg.sender]
            .withdrawed
        ) = true;

        //emit an event
        emit Withdrawed(
            msg.sender,
            marketId,
            _rewardAmount,
            _expertScore
        );
    }

    //caclulating reward
    function calcReward(
        bytes32 _marketId,
        address _playerAddress
    ) public view returns(uint256){

        uint256[2] memory _moneyWaged = markets[_marketId].moneyWaged;
        Player memory _player = markets[_marketId].players[_playerAddress];
        uint256 _winningOutcome = markets[_marketId].winningOutcome;

        //total amount of money waged on losing outcomes
        uint256 _loserMoney = (
            _moneyWaged.sumArr() -
            _moneyWaged[_winningOutcome]
        );

        //the amount money waged by the player on the winning outcomes
        uint256 _winOutcomeMoney = (
            _player.moneyWaged[_winningOutcome]
        );

        //total amount of winning shares owned by th player
        uint256 _winSharesOwned = (
            _player.sharesOwned[_winningOutcome]
        );

        return (
            (
                (MULTIPLIER * _loserMoney) / _winSharesOwned
            ) +
             _winOutcomeMoney
        );
    }

    //caclulating expert score
    function calcExpertScore(
        bytes32 _marketId,
        address _playerAddress
    ) public view returns(uint256){

        uint256[2] memory _moneyWaged = markets[_marketId].moneyWaged;
        uint256[2] memory _sharesOwned = markets[_marketId].sharesOwned;
        Player memory _player = markets[_marketId].players[_playerAddress];
        uint256 _winningOutcome = markets[_marketId].winningOutcome;

        //total amount of shares owned by the player
        uint256 _totalSharesPlayer = (
            _player.sharesOwned.sumArr()
        );

        //total amount of winning outcome shares owned by the player
        uint256 _totalWinSharesPlayer = (
            _player.sharesOwned[_winningOutcome]
        );

        //total amount of winning outcome shares
        uint256 _totalWinShares = (
            _sharesOwned[_winningOutcome]
        );

        //total amount of losing outcomes shares
        uint256 _totalLosingShares = (
            _sharesOwned[1 - _winningOutcome]
        );

        //total amount of shares owned
        uint256 _totalShares = (
            _totalWinShares + _totalLosingShares
        );

        //total amount of money waged on a market
        uint256  _totalMoneyWaged = (
            _moneyWaged.sumArr()
        );

        return (
            (
                (_totalMoneyWaged * _totalWinSharesPlayer) /
                (_totalWinShares + _totalSharesPlayer)
            ) *
            (2 * _totalLosingShares) /
            _totalShares
        );
    }

    //calculating price of buying n shares of outcome i
    function _priceBuyShares(
        bytes32 _marketId,
        uint256 _outcome,
        uint256 _nshares
    ) internal view returns(uint256){



        //amount of money waged on the outcome to be bought
        uint256 m = (
            markets
            [_marketId]
            .moneyWaged
            [_outcome]
        );

        //the amount of money waged on the opposite outcome
        uint256 n = (
            markets
            [_marketId]
            .sharesOwned
            [1 - _outcome]
        );

        return (
            m *
            (
                MathContract.exp((MathContract.ONE * _nshares) / (ALPHA * n)) -
                MathContract.ONE
            ) /
            MathContract.ONE
        );
    }

    //getting winning outcome based on the price
    function _getWinningOutcome(
        bytes32 _marketId
    ) internal view returns(uint256) {

        uint256 _resolutionPrice = markets[_marketId].resolutionPrice;
        uint256 _benchPrice = markets[_marketId].benchPrice;

        if(_resolutionPrice >= _benchPrice){
            return 1;
        } else {
            return 0;
        }
    }



    //validating shares owned
    function _validateSharesOwned(
        uint256[2] memory _sharesOwned
    ) internal pure{
        for(uint256 i = 0; i <= _sharesOwned.length; i++){
            require(_sharesOwned[i] > 0);
        }
    }

    //validating money waged
    function _validateMoneyWaged(
        uint256[2] memory _moneyWaged
    ) internal pure{
        for(uint256 i = 0; i <= _moneyWaged.length; i++){
            require(_moneyWaged[i] > 0);
        }
    }

    function checkUpkeep(bytes calldata checkData) external view  override returns (
        bool upkeepNeeded,
        bytes memory performData
    )
    {
        bytes32[30] memory resolvedMarketIds;
        bytes32 _marketId;
        bool _resolved;
        uint256 count;

        for(uint256 i; i < numMarkets; i++){

            require(count < 30);

            _marketId = marketIds[i];
            _resolved = markets[_marketId].resolved;

            if(!markets[_marketId].resolved){
                resolvedMarketIds[i] = _marketId;
                count += 1;
            }
        }
        if(count > 0){
            upkeepNeeded = true;
        }
        return (upkeepNeeded, abi.encode(resolvedMarketIds));
    }

    function performUpkeep(bytes calldata performData) external override {

        bytes32[30] memory resolvedMarketIds = abi.decode(
            performData,
            (bytes32[30])
        );
        PriceFeeder _priceFeeder;
        bytes32 _marketId;

        for(uint256 i; i < resolvedMarketIds.length; i++){
            _marketId = resolvedMarketIds[i];
            require(!markets[_marketId].resolved);

            _priceFeeder = (
                markets
                [resolvedMarketIds[i]]
                .priceFeeder
            );

             _priceFeeder.requestPrice();
            markets[resolvedMarketIds[i]].resolutionPrice = (
                _priceFeeder.price()
            );

            markets[_marketId].resolved = true;

            emit MarketResolved(_marketId);
        }
    }

}
