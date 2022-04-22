// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./helper_contracts/Maths.sol";
import "./helper_contracts/MarketObjects.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


contract Markets {

    using MathContract for *;
    using MarketObjects for *;

    // deposit event
    event Deposited(
        address player,
        uint256 marketId,
        uint256[2] sharesBought,
        uint256[2] moneyWaged
    );

    // withdraw event
    event Withdrawed(
        address player,
        uint256 betId,
        uint256 moneyWithdrawed,
        uint256 expertScore
    );

    // market created event
    event MarketCreated(
        uint256 marketId
    );

    // constants
    uint256 constant MULTIPLIER = 1000000000000000000;
    uint256 constant ALPHA = 100;
    IERC20 linkToken;

    //the amount of markets created
    uint256 numMarkets;

    //mapping to store all the bets. The bet is identified by its betId
    mapping(bytes32 => Markets) public markets;

    //mapping to store marketIds
    mapping(uint256 => bytes32) public marketIds;

    //function to create a bet
    function createMarket(
        uint256[2] memory _sharesOwned,
        uint256[2] memory _moneyWaged,
        bytes32 _assetName,
        uint256 _benchPrice,
        uint256 _resolutionDate,
        uint256 _wageDeadline,
        address _payTokenAddress
    ) external {

        //checking date conditions
        require(now < _resolutionDate);
        require(now < _wageDeadline);
        require(_wageDeadline < _resolutionDate);

        //checking money waged and shares owned conditions
        _validateMoneyWaged(_moneyWaged);
        _validateSharesOwned(_sharesOwned);

        //define mappings for players
        mapping(address => Player) players;
        //initialize reward for the player
        uint256 _reward;
        //initialize expert score for the player
        uint256 _expertScore;

        Player _player = Player(
            _moneyWaged,
            _sharesOwned,
            _reward,
            _expertScore,
            false
        );
        _players[msg.sender] = _player;

        //deploy price feeder contract
        PriceFeeder _priceFeeder = new PriceFeeder(_assetName);

        IERC20 _payToken = IERC20(_payTokenAddress);

        uint256 _resolutionPrice;
        uint256 _winningOutcome;
        bool _resolved;

        //get marketId
        uint256 marketId = keccak256(
            abi.encodePacked(msg.sender, _priceFeederAddress)
        );

        //crypto market initialization
        Market bet = Market(
            _players,
            _sharesOwned,
            _moneyWaged,
            _assetName,
            _benchPrice,
            _resolutionPrice,
            _winningOutcome,
            _resolutionDate,
            _wageDeadline,
            _resolved,
            _payToken,
            _priceFeeder
        );

        markets[marketId] = market;
        marketIds[numMarkets] = marketId;
        numMarkets += 1;

        emit MakretCreated(marketId);

        emit Deposited(
            BetId,
            msg.sender,
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
        require(markets[marketId].wageDeadline > now);

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
        markets[marketId].token.transferFrom(
            msg.sender,
            address(this),
            _transferAmount
        );

        //update moneyWage and sharesOwned both for market and for a player
        for(uint256 i; i <  _sharesToPurchase.length; i++){

            market[marketId].sharesOwned[i] += _sharesToPurchase[i];
            market[marketId].moneyWaged[i] += _moneyToWage[i];

            (
                market
                [marketId]
                .players
                [msg.sender]
                .sharesOwned
            ) += _sharesToPurchase[i];

            (
                market
                [marketId]
                .players
                [msg.sender]
                .moneyWaged
            ) += _moneyToWage[i];

        }

        // emit deposit events
        emit Deposited(marketId, msg.sender, _sharesToPurchase, _moneyToWage);
    }

    //withdrawing money from a market
    function withdraw(uint256 marketId) external {

        //check that market is resolved
        require(markets[marketId].resolved);
        /*
            check that the player had not previously
            withdrawed money from this market
        */
        require(~markets[marketId].players[msg.sender].withdrawed);

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
        ) = _rewardAmount;

        //update the player's expert score data
        (
            markets
            [marketId]
            .players
            [msg.sender]
            .expertScore
        ) = _expertScore;

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
            marketId,
            msg.sender,
            _rewardAmount,
            _expertScore
        );
    }

    //caclulating reward
    function calcReward(
        uint256 _marketId,
        address _player
    ) public view returns(uint256){

        Market market = markets[marketId];
        uint256 winningOutcome = market.winningOutcome;

        //total amount of money waged on losing outcomes
        uint256 _loserMoney = (
            market.moneyWaged.sumArr() -
            market.moneyWaged[winningOutcome]
        );

        //the amount money waged by the player on the winning outcomes
        uint256 _winOutcomeMoney = (
            market.players[_player].moneyWaged[winningOutcome]
        );

        //total amount of winning shares owned by th player
        uint256 _winSharesOwned = (
            market.players[_player].sharesOwned[winningOutcome]
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
        uint256 marketId,
        address _player
    ) public view returns(uint256){

        Market market = markets[marketId];
        uint256 winningOutcome = market.winningOutcome;

        //total amount of shares owned by the player
        uint256 _totalSharesPlayer = (
            market.players[_player].sharesOwned.sumArr()
        );

        //total amount of winning outcome shares owned by the player
        uint256 _totalWinSharesPlayer = (
            market.players[_player].sharesOwned[_winningOutcome]
        );

        //total amount of winning outcome shares
        uint256 _totalWinShares = (
            market.sharesOwned[_winningOutcome]
        );

        //total amount of losing outcomes shares
        uint256 _totalLosingShares = (
            market.sharesOwned[1 - _winningOutcome]
        );

        //total amount of shares owned
        uint256 _totalShares = (
            _totalWinShares + _totalLosingShares
        );

        //total amount of money waged on a market
        uint256  _totalMoneyWaged = (
            market.moneyWaged.sumArr()
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

        return (m * exp((ONE * nshares) / (ALPHA * n)) - m * ONE) / ONE;
    }

    //getting winning outcome based on the price
    function _getWinningOutcome(
        bytes32 _marketId
    ) internal returns(uint256) {

        Market market = markets[marketId];

        if(market.resolutionPrice >= market.benchPrice){
            return 1;
        } else {
            return 0;
        }
    }

    //validating shares owned
    function _validateSharesOwned(
        uint256[2] calldata _sharesOwned
    ) internal pure{
        for(uint256 i = 0; i <= _sharesOwned.length; i++){
            require(_sharesOwned[i] > 0);
        }
    }

    //validating money waged
    function _validateMoneyWaged(
        uint256[2] calldata _moneyWaged
    ) internal pure{
        for(uint256 i = 0; i <= _moneyWaged.length; i++){
            require(_moneyWaged[i] > 0);
        }
    }

}
