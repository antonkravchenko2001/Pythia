// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./MathContract.sol";
import "./PriceFeeder.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


contract CryptoMarkets {

    // deposit event
    event Deposited(
        address player,
        uint256 betId,
        uint256[2] shares,
        uint256[2] money_waged
    );

    // withdraw event
    event Withdrawed(
        address player,
        uint256 betId,
        uint256 money,
        uint256 expertScore
    );

    // bet created event
    event BetCreated(
        uint256 betId
    );

    //coef to used in pricing
    uint256 constant ALPHA = 100;

    //address of the link token
    address constant LINK_ADDRESS = address(
        0x326C977E6efc84E512bB9C30f76E30c160eD06FB
    );

    //initiaizing link token contract
    IERC20 linkToken = IERC20(LINK_ADDRESS);

    // bet struct
    struct BinaryBet{
        //total amount of shares owned for each outcome
        uint256[2] sharesOwned;
        //total amount of money waged for each outcome
        uint256[2] moneyWaged;
        //mapping player => amount of shares of each outcome owned by a player
        mapping(address => uint256[2]) playerSharesOwned;
        //mapping player => amount of money of money waged on each outcome by a player
        mapping(address => uint256[2]) playerMoneyWaged;
        //Resolution date
        uint256 resolutionDate;
        // The last date to wage money on a bet
        uint256 wageDeadline;
        //the asset name
        uint256 assetName;
        //value to compare the price of the asset with to determine the outcome
        uint256 betVal;
        //address of the price feeder contract
        uint256 priceFeederAdress;
    }

    //mapping to store all the bets. The bet is identified by its betId
    mapping(bytes32 => BinaryBet) public bets;


    //function to create a bet
    function createCryptoBet(
        uint256[2] memory _sharesOwned,
        uint256[2] memory _moneyOwned,
        uint256 _resolutionDate,
        uint256 _wageDeadline,
        address _tokenAddress,
        bytes32 _assetName,
        uint256 _betVal
    ) external {

        //checking date conditions
        require(now < _resolutionDate);
        require(now < _wageDeadline);
        require(_wageDeadline < _resolutionDate);

        //checking money waged and shares owned conditions
        _validateMoneyWaged(_moneyWaged);
        _validateSharesOwned(_sharesOwned);

        //get instanteneous price
        _instanteneousPrice = _getInstanteneousPrice(
            _moneyWaged,
            _sharesOwned
        );

        //define mappings for players
        mapping(address => uint256[2]) _playerSharesOwned;
        mapping(address => uint256[2]) _playerMoneyWaged;

        _playerSharesOwned[msg.sender] = _sharesOwned;
        _playerMoneyWaged[msg.sender] = _moneyWaged;

        //deploy price feeder contract
        PriceFeeder _priceFeeder = new PriceFeeder(betId);

        //fund price feeder
        require(linkToken.balanceOf(msg.sender) >= _priceFeeder.fee);
        linkToken.transferFrom(
            msg.sender,
            address(_priceFeeder),
             _priceFeeder.fee
        );

        //request price
        _priceFeeder.requestPrice(_assetName, _resolutionDate);

        //get bet token
        token = IERC20(_tokenAddress);

        //get beId
        uint256 betId = keccak256(
            abi.encodePacked(msg.sender, _priceFeederAddress)
        );

        //crypto bet initialization
        CryptoBet bet = CryptoBet(
            _sharesOwned,
            _moneyWaged,
            _playerSharesOwned,
            _playerMoneyWaged,
            _resolutionDate,
            _wageDeadline,
            _assetName,
            _betVal,
            _priceFeeder.address
        );

        bets[betId] = bet;

        emit BetCreated(BetId);

        emit Deposited(
            BetId,
            msg.sender,
            _moneyWaged,
            _sharesOwned
        );

    }
    function wageMoney(
        uint256 betId,
        uint256[2] memory buyShares
    ) external {

        //check that wage deadline is not passed
        require(
            bets[betId].wageDeadline > now,
            "Deadline has passed"
        );

        //wage amounts for each outcome
        uint256[2] memory _wageAmounts;
        //total cost
        uint256 _transferAmount = _wageAmounts.sumArr();

        for(uint8 i = 0; i < buyShares.length; i++){
            _wageAmounts[i] += _priceBuyShares(betId, i, buyShares[i]);
        }

        //check if player has sufficient funds
        require(
            bets[betId].token.balanceOf(msg.sender) >= _transferAmount,
            "Insufficient funds"
        );

        //transfer funds
        bet.token.transferFrom(
            msg.sender,
            address(this),
            _transferAmount
        );

        //update moneyWage and sharesOwned
        for(uint8 i; i < buyShares.length; i++){

            bets[betId].sharesOwned[i] += buyShares[i];
            bets[betId].moneyWaged[i] += _wageAmounts[i];

            bets[betId].playerSharesOwned[msg.sender][i] += buyShares[i];
            bets[betId].playerMoneyWaged[msg.sender][i] += _wageAmounts[i];

        }

        // emit deposit events
        emit Deposited(betId, msg.sender, buyShares, _moneyWaged);
    }

    function withdraw(uint256 betId) external {

        require(bets[betId].resolutionDate <= now);

        uint256 _rewardAmount = getRewardAmount(betId, msg.sender);

        uint256 _expertScore = getExpertScore(betId, msg.sender);

        bets[betId].token.transfer(msg.sender, _rewardAmount);

        bets[betId].playerSharesOwned[msg.sender][winningOutcome] = 0;
        bets[betId].playerMoneyWaged[msg.sender][winningOutcome] = 0;

        emit Withdrawed(
            betId,
            msg.sender,
            _rewardAmount,
            _expertScore
        );
    }

    function getRewardAmount(
        uint256 betId,
        address _address
    ) public view returns(uint256){

        uint256 bet = bets[betId];

        uint256 _moneyFromLosers = (
            (bet.moneyOwned.sumArr() - money[bet.winningOutcome]) *
            bet.playerSharesOwned[msg.sender][bet.winningOutcome] /
            bet.sharesOwned[bet.winningOutcome]
        );

        uint256 _moneyInWinShares = (
            bet.playerMoneyWaged[msg.sender][bet.winningOutcome]
        );

        uint256 _rewardAmount = _moneyFromLosers + _moneyInWinShares;

        return _rewardAmount;
    }

    function getExpertScore(
        uin256 betId,
        address _address
    ) public view returns(uint256){

        uint256 bet = bets[betId];

        uint256 _winningShares = (
            bet.playerSharesOwned[_address][bet.winningOutcome] * 10 ** 6
        );

        uint256 _winningIn = _winningShares / (
            bet.sharesOwned[bet.winningOutcome]
        );
        uint256 _winningOut = (
            _winningShares / bet.playerSharesOwned[_address].sumArr()
        );

        uint256 _losingSharesFrac = (
            (
                amountShares - bet.sharesOwned[bet.winningOutcome]
            ) * 10 ** 12 / amountShares
        );

        uint256 _playerScore = (
            (2 * _winningIn * _winningOut) / (_winningIn + _winningOut)
        );

        return _playerScore * _losingSharesFrac * amountMoney;
    }


    function _priceBuyShares(
        bytes32 betId,
        uint8 outcome,
        uint256 nshares
    ) internal view returns(uint256){

        uint256 bet = bets[betId];

        return (
            expABC(
                bet.moneyWaged[outcome],
                nshares,
                ALPHA * bet.sharesOwned[1 - outcome],
                SERIES_LENGTH
            ) - bet[betName].moneyWaged[outcome],
        );
    }

    function _getWinningOutcome(
        uint256 betId,
        bytes32 _assetName,
        bytes32 _resolutionDate,
        uint256 _betVal
    ) internal returns(uint8) {

        _priceFeederAddress = bets.betId.priceFeederAddress;

        PriceFeeder priceFeeder = PriceFeeder(_PriceFeederAddress);

        if(priceFeeder.price >= _benchValue){
            return 1;
        }
        return 0;
    }

    function _getInstanteneousPrice(
        uint256[2] _moneyWaged,
        uint256[2] _sharesOwned
    ) external pure returns(uint256[2] memory){

        uint256[2] memory _instanteneousPrice;
        for(uint8 i = 0; i < _sharesOwned.length; i++){
            _instanteneousPrice[i] = (
                _moneyWaged[i] / (ALPHA * _sharesOwned[1 - i])
            );
        }
        return _instanteneousPrice;
    }

    function _validateSharesOwned(
        uint256[2] calldata _sharesOwned
    ) internal pure{
        for(uint8 i = 0; i <= _sharesOwned.length; i++){
            require((_sharesOwned[i] > 0) & (_sharesOwned < 10 ** 9));
        }
    }

    function _validateMoneyWaged(
        uint256[2] calldata _moneyWaged
    ) internal pure{
        for(uint8 i = 0; i <= _moneyWaged.length; i++){
            require(_moneyWaged[i] > 0);
        }
    }

}
