// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./maths/Maths.sol";
import "./ERC20_contracts/IERC20.sol";
import "./chainlink_contracts/price_feeders/PriceFeeder.sol";
import "./chainlink_contracts/keepers/KeeperCompatibleInterface.sol";



contract Markets is KeeperCompatibleInterface{

    using MathContract for *;

    // deposit event
    event Deposited(
        uint256 marketId,
        address player,
        uint256[2] sharesBought,
        uint256[2] moneyWaged
    );

    // withdraw event
    event Withdrawed(
        uint256 marketId,
        address player,
        uint256 moneyWithdrawed,
        uint256 expertScore
    );

    // market created event
    event MarketCreated(
        uint256 marketId
    );

    //market resolved event
    event MarketResolved(
        uint256 marketId
    );

    //player within market representation
    struct Player{
        //the amount of shares owned by the player on each of the outcomes
        uint256[2] sharesOwned;
        //the amount of money waged by the player on each of the outcomes
        uint256[2] moneyWaged;
        //reward recieved by the player when he withdraws after market resolution
        uint256 reward;
        //expert score recieved by the player when he withdraws after market resolution
        uint256 expertScore;
        //flag representing whether the player withdrawed or not
        bool withdrawed;
    }


    // market representation
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
        uint256 strikePrice;
        //resolution price
        uint256 resolutionPrice;
        //The last date to wage money on a bet
        uint256 wageDeadline;
        //Resolution date
        uint256 resolutionDate;
        //winning outcome
        uint256 winningOutcome;
        //resolved flag
        bool resolved;
    }

    //multiplier used in computations
    uint256 constant MULTIPLIER = 10 ** 18;
    //alpha hyperparamter used in the price function for a market
    uint256 constant ALPHA = 4;
    //the maximum amount of markets that can be resolved within one block
    uint256 constant MAX_MARKETS_UPDATE = 30;
    //keepers fee
    uint256 constant KEEPER_FEE = 10 ** 5;
    //maximum amount of markets that can be stored in the contract
    uint256 constant MAX_AMOUNT_MARKETS = 1000;

    //payToken
    IERC20 payToken;
    //linkToken
    IERC20 linkToken;
    //price feeder contract
    PriceFeeder priceFeeder;

    //the amount of markets created
    uint256 public numMarkets;

    //mapping to store all the bets. The bet is identified by its betId
    mapping(uint256 => Market) markets;

    //initialize pay and link stoken
    constructor(
        address payesTokenAddress,
        address linkTokenAddress,
        address priceFeederAddress
    ) public {
        payToken = IERC20(payesTokenAddress);
        linkToken = IERC20(linkTokenAddress);
        priceFeeder = PriceFeeder(priceFeederAddress);
    }

    //function to create a bet
    function createMarket(
        uint256[2] memory _sharesOwned,
        uint256[2] memory _moneyWaged,
        address _priceFeedAddress,
        uint256 _strikePrice,
        uint256 _resolutionDate,
        uint256 _wageDeadline
    ) external {

        // check the the amount of markets does not exceed the max amount
        require(
            numMarkets < MAX_AMOUNT_MARKETS,
            "the market amount limit reached, redeploy the contract"
        );

        //check that resolution date has not passed
        require(
            block.timestamp < _resolutionDate,
            "resolution date has passed"
        );

        //check that wage deadline date has not passed
        require(
            block.timestamp < _wageDeadline,
            "wage deadline has passed"
        );

        //check that wage deadline date does not exceed the resolution date
        require(
            _wageDeadline <= _resolutionDate,
            "resolution happens after last wage"
        );

        //trasfer amount
        uint256 _transferAmount = _moneyWaged.sumArr();

        //check that person has funds
        require(
            payToken.balanceOf(msg.sender) > _transferAmount,
            "insufficient player funds in pay token"
        );
        require(
            linkToken.balanceOf(msg.sender) > KEEPER_FEE,
            "insufficient player link funds"
        );


        //initialize the market
        Market storage market = markets[numMarkets];

        //initialize the player (one who creates a market is the first player)
        {
            Player memory _player;
            _player.sharesOwned = _sharesOwned;
            _player.moneyWaged = _moneyWaged;
            //add player to market players
            market.players[msg.sender] = _player;
        }

        //assign shares owned
        market.sharesOwned = _sharesOwned;
        // assign money waged
        market.moneyWaged = _moneyWaged;
        //assign price feed address
        market.priceFeedAddress = _priceFeedAddress;
        //assign strike price
        market.strikePrice = _strikePrice;
        // assign resolution date
        market.resolutionDate = _resolutionDate;
        // assign wage  deadline
        market.wageDeadline = _wageDeadline;

        // validate the market
        _validateMarket(numMarkets);


        // emit event that market is created
        emit MarketCreated(numMarkets);

        //emit event that the money was deposited
        emit Deposited(
            numMarkets,
            msg.sender,
            _moneyWaged,
            _sharesOwned
        );

        //increment the num markets by 1
        numMarkets += 1;

        // // transfer funds
        // payToken.transferFrom(
        //     msg.sender,
        //     address(this),
        //     _transferAmount
        // );

        // linkToken.transferFrom(
        //     msg.sender,
        //     address(this),
        //     KEEPER_FEE
        // );
    }

    //waging money on a market
    function wageMoney(
        uint256 _marketId,
        uint256[2] memory _moneyToWage
    ) external {

        //check that wage deadline is not passed
        require(
            markets[_marketId].wageDeadline > block.timestamp,
            "wage deadline has passed"
        );

        //validate the market
        _validateMarket(_marketId);

        uint256[2] memory _sharesToPurchase;

        //amount of money to be waged for each outcome
        for(uint256 i = 0; i < _sharesToPurchase.length; i++){
            _sharesToPurchase[i] += numSharesForPrice(
                _marketId,
                i,
                _moneyToWage[i]
            );
        }



        //check tha the player has sufficient funds
        require(
            payToken.balanceOf(msg.sender) >= _moneyToWage.sumArr()
        );

        //update moneyWage and sharesOwned both for market and for a player
        for(uint256 i; i <  _sharesToPurchase.length; i++){

            //update the shares owned of each outcome for the market
            markets[_marketId].sharesOwned[i] += _sharesToPurchase[i];
            //update the money waged on each outcome for the market
            markets[_marketId].moneyWaged[i] += _moneyToWage[i];

            //update the shares owned of each outcome for the player within the market
            (
                markets
                [_marketId]
                .players
                [msg.sender]
                .sharesOwned
                [i]
            ) += _sharesToPurchase[i];

            //update the money waged on each outcome for the player within the market
            (
                markets
                [_marketId]
                .players
                [msg.sender]
                .moneyWaged
                [i]
            ) += _moneyToWage[i];

        }

        _validateMarket(_marketId);

        //transfer funds
        payToken.transferFrom(
            msg.sender,
            address(this),
            _moneyToWage.sumArr()
        );

        // emit deposit events
        emit Deposited(
            _marketId,
            msg.sender,
            _sharesToPurchase,
            _moneyToWage
        );
    }

    //withdrawing money from a market
    function withdraw(uint256 _marketId) external {

        //validate the market
        _validateMarket(_marketId);

        //check that the market is resolved
        require(markets[_marketId].resolved);
        /*
            check that the player had not previously
            withdrawed money from this market
        */
        require(!markets[_marketId].players[msg.sender].withdrawed);

        //calculate reward
        uint256 _rewardAmount = _calcReward(_marketId, msg.sender);
        //calculate expert score
        uint256 _expertScore = _calcExpertScore(_marketId, msg.sender);

        //update the player's reward info (within the market)
        (
            markets
            [_marketId]
            .players
            [msg.sender]
            .reward
        ) = _rewardAmount;

        //update the player's expert score info (within the market)
        (
            markets
            [_marketId]
            .players
            [msg.sender]
            .expertScore
        ) = _expertScore;

        //update the player's withdrawed flag (within the market)
        (
            markets
            [_marketId]
            .players
            [msg.sender]
            .withdrawed
        ) = true;

        //reward the player
        payToken.transfer(msg.sender, _rewardAmount);

        //emit an event
        emit Withdrawed(
            _marketId,
            msg.sender,
            _rewardAmount,
            _expertScore
        );
    }

    //check events for resolution
    function checkUpkeep(bytes calldata checkData) external view override returns (
        bool upkeepNeeded,
        bytes memory performData
    )
    {
        //an array to store markets ids of the markets to be resolved
        uint256[MAX_MARKETS_UPDATE] memory _resolvedMarketIds;


        uint256 _count;

        for(uint256 i; i < numMarkets; i++){
            //check that number of markets to be resolved < MAX_MARKETS_UPDATE
            if(_count >= MAX_MARKETS_UPDATE){
                break;
            }

            if(
                (!markets[i].resolved) &&
                (markets[i].resolutionDate <= block.timestamp)
            ){
                //fill array with id of the market
                _resolvedMarketIds[_count] = i;
                _count += 1;
            }
        }

        //check that upkeep is needed
        if(_count > 0){
            upkeepNeeded = true;
        }
        return (upkeepNeeded, abi.encode(_resolvedMarketIds));
    }

    //update prices
    function performUpkeep(bytes calldata performData) external override {

        //get an array of markets ids for which to query price
        uint256[MAX_MARKETS_UPDATE] memory _resolvedMarketIds = abi.decode(
            performData,
            (uint256[30])
        );

        uint256 _marketId;

        for(uint256 i; i < _resolvedMarketIds.length; i++){
            _marketId = _resolvedMarketIds[i];

            //double check that the market is not resolved
            if(
                (!markets[_marketId].resolved) &&
                (markets[_marketId].resolutionDate <= block.timestamp)
            ){

                //get latest price
                markets[_marketId].resolutionPrice = (
                    priceFeeder.getLatestPrice(
                        markets[_marketId].priceFeedAddress
                    )
                );

                //mark the market as resolved
                markets[_marketId].resolved = true;

                //emit an event
                emit MarketResolved(_marketId);
            }
        }
    }

    //get market info
    function getMarketInfo(uint256 _marketId) external view returns(
        address,
        uint256[2] memory,
        uint256[2] memory,
        uint256[2] memory,
        uint256[2] memory,
        bool,
        uint256
    ){
         return(
            markets[_marketId].priceFeedAddress,
            [
                markets[_marketId].strikePrice,
                markets[_marketId].resolutionPrice
            ],
            [
                markets[_marketId].wageDeadline,
                markets[_marketId].resolutionDate
            ],
            markets[_marketId].sharesOwned,
            markets[_marketId].moneyWaged,
            markets[_marketId].resolved,
            markets[_marketId].winningOutcome
        );
    }

    //get player info
    function getPlayerInfo(address _player, uint256 _marketId) external view returns(
        uint256[2] memory,
        uint256[2] memory,
        uint256,
        uint256,
        bool
    ) {
        return (
            markets[_marketId].players[_player].sharesOwned,
            markets[_marketId].players[_player].moneyWaged,
            markets[_marketId].players[_player].reward,
            markets[_marketId].players[_player].expertScore,
            markets[_marketId].players[_player].withdrawed
        );
    }

    //get num markets
    function getNumMarkets() external view returns(uint256){
        return numMarkets;
    }

    //get num markets
    function getLinkFee() external pure returns(uint256){
        return KEEPER_FEE;
    }

    //caclulating reward
    function _calcReward(
        uint256 _marketId,
        address _playerAddress
    ) public view returns(uint256){
        //require for market to be resolved;
        require(markets[_marketId].resolved);

        //money waged on each outcome in the market
        uint256[2] memory _moneyWaged = markets[_marketId].moneyWaged;
        //the player
        Player memory _player = markets[_marketId].players[_playerAddress];
        //the winning outcome of the market
        uint256 _winningOutcome = markets[_marketId].winningOutcome;


        //total amount of money waged on losing outcomes
        uint256 _totalLoserMoney = (
            _moneyWaged[1 - _winningOutcome]
        );
        //the amount money waged by the player on the winning outcomes
        uint256 _winOutcomeMoney = (
            _player.moneyWaged[_winningOutcome]
        );
        //total amount of winning shares owned by th player
        uint256 _winSharesOwned = (
            _player.sharesOwned[_winningOutcome]
        );
        //total win shares
        uint256 _totalWinShares = (
            markets[_marketId].sharesOwned[_winningOutcome]
        );
        //denominator > 0
        require( _winSharesOwned > 0);

        return (
            (
                _winSharesOwned * _totalLoserMoney +
                _totalWinShares * _winOutcomeMoney
            ) /
            _totalWinShares
        );
    }

    //caclulating expert score
    function _calcExpertScore(
        uint256 _marketId,
        address _playerAddress
    ) public view returns(uint256){

        //require for market to be resolved;
        require(markets[_marketId].resolved);

        //money waged on each outcome in the market
        uint256[2] memory _moneyWaged = markets[_marketId].moneyWaged;

        //shares owned of each outcome for the market
        uint256[2] memory _sharesOwned = markets[_marketId].sharesOwned;

        //the player
        Player memory _player = markets[_marketId].players[_playerAddress];

        //the winning outcome of the market
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
    function numSharesForPrice(
        uint256 _marketId,
        uint256 _outcome,
        uint256 _moneyToWage
    ) public view returns(uint256){

        //amount of money waged on the outcome to be bought
        uint256 _moneyOutcome = (
            markets
            [_marketId]
            .moneyWaged
            [_outcome]
        );

        //the amount of money waged on the opposite outcome
        uint256 _sharesOppositeOutcome = (
            markets
            [_marketId]
            .sharesOwned
            [1 - _outcome]
        );

        //ln(1 + m1 / M1) * alpha * N2
        //ln((M1 + m1) * ONE / M1) * alpha * N2 / ONE
        return (
            (
                (MathContract.one() *
                (_moneyOutcome + _moneyToWage) /
                _moneyOutcome).ln()
            ) *
            ALPHA *
            _sharesOppositeOutcome /
            MathContract.one()
        );
    }

    //getting winning outcome based on the price
    function _getWinningOutcome(
        uint256 _marketId
    ) internal view returns(uint256) {

        //get resolution price
        uint256 _resolutionPrice = markets[_marketId].resolutionPrice;
        //get strike price
        uint256 _strikePrice = markets[_marketId].strikePrice;

        //compare them to one another
        if(_resolutionPrice >= _strikePrice){
            return 1;
        } else {
            return 0;
        }
    }

    //validating the market
    function _validateMarket(
        uint256 _marketId
    ) internal view{
        //validating money waged
        {
            uint256[2] memory _moneyWaged = markets[_marketId].moneyWaged;
            for(uint256 i = 0; i < _moneyWaged.length; i++){
                require(
                    _moneyWaged[i] > 0,
                    "money waged can't be 0"
                );
            }
        }

        //validating shares Owned
        {
            uint256[2] memory _sharesOwned = markets[_marketId].sharesOwned;
            for(uint256 i = 0; i < _sharesOwned.length; i++){
                require(
                    _sharesOwned[i] > 0,
                    "shares owned can't be 0"
                );
            }
        }
    }

}
