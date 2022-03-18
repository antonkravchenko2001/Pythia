// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "./EventsEmitter.sol";
import "./MathContract.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";



contract CryptoBet {

    using MathContract for *;

    uint256[2] shares;
    uint256 amountShares;

    uint256[2] money;
    uint256 amountMoney;

    mapping(address => uint256[2]) addressShares;
    mapping(address => uint256[2]) addressMoney;

    uint128[2] betValues;

    uint256 resolutionDate;
    uint256 wageDeadline;

    IERC20 token;

    string assetName;

    uint8 winningOutcome;

    address emmiterAddress;
    uint8 MIN_PRICE_SHARE = 2;
    bytes32 JOB_ID = "9ea03a32a0074fb18cf6f072190e9855";
    address ORACLE_ADDRESS = address(0x34195E3eD889BBe21a532A48Ec90A845f65b9dFA);


    constructor(
        uint256[2] _shares,
        uint256[2] _money,
        uint128[2] _betValues,
        uint256 _resolutionDate,
        uint256 _wageDeadline,
        IERC20 _token,
        string _assetName
    ) public {

        shares = _shares;
        amountShares = shares.sumArr();
        assetName = _assetName;
        money = _money;
        amountMoney = money.sumArr();

        betValues = _betValues;

        resolutionDate = _resolutionDate;
        wageDeadline = _wageDeadline;

        token = IERC20(token_address);

        require(amountMoney >= 0);
        require(amountShares >= 0);

        string assetRequest = (
            "https://api.coingecko.com/api/v3/simple/price?ids=" +
            _assetName +
            "&vs_currencies=usd"
        );

        uint256 instanteneousPrice = _instanteneousPrice();
        EventsEmitter emitter = EventsEmitter(emmiterAddress);
        _validate_outcomes();

    }

    using MathContract for uint256;

    function wageMoney(uint256[2] buyShares) external returns(bool){

        uint256 _totalPrice = 0;
        uint256 _numShares = 0;
        uint[2] _moneyWaged;

        for(uint8 i = 0; i < buyShares.length; i++){
            _totalPrice += _priceBuyShares(i, buyShares[i]);
            _numShares += buyShares[i];
        }

        require(token.balanceOf(msg.sender) >= total_price);

        for(uint8 i; i < buyShares.length; i++){
            require(
               (
                   (shares[i] + buyShares[i]) *
                   (10 ** 18) /
                   (amountShares + buyShares[i])
               ) >= MIN_PRICE_SHARE * 10 ** 16
            );
        }

        for(uint8 i; i < buyShares.length; i++){

            shares[i] += buyShares[i];

            instanteneousPrice[i] += (
                buyShares[i] *
                (10 ** 18) /
                (amountShares + buyShares[i])
            );

            _moneyWaged[i] = _priceBuyShares(i, buyShares[i]);

            money[i] += _moneyWaged[i];

            for(uint8 j; j < numShares.length; j++){

                addressMoney[msg.sender][j] += money_waged[j];
                addressShares[msg.sender][j] += buyShares[j];

            }
        }

        token.transferFrom(msg.sender, this.address, total_price);
        emitter.EmitDeposit(msg.sender, this.address, buyShares, money_waged);
    }

    function withdraw(uint256[2] shares) external returns(bool){

        require(_resolutionDate >= block.timestamp);

        uint256 _rewardAmount = getRewardAmount(msg.sender);

        uint256 _expertScore = calcExpertScore(msg.sender);

        token.transfer(msg.sender, _rewardAmount);

        addressShares[msg.sender][winningOutcome] = 0;
        addressMoney[msg.sender][winningOutcome] = 0;

        emitter.EmitWithdraw(
            msg.sender,
            this.address,
            _rewardAmount,
            expertScore
        );
    }

    function getRewardAmount(address _address) external view returns(uint256){

        uint256 _moneyFromLosers = (
            (money - money[winningOutcome]) *
            addressShares[msg.sender][winningOutcome] /
            shares[winningOutcome]
        );

        uint256 _moneyInWinShares = addressMoney[msg.sender][winningOutcome];

        uint256 _rewardAmount = _moneyFromLosers + _moneyInWinShares;

        return _rewardAmount;
    }

    function getExpertScore(address _address) external view returns(uint256){

        uint256 _winningShares = (
            addressShares[_address][winningOutcome] * 10 ** 6
        );

        uint256 _winningIn = _winningShares / shares[winningOutcome];
        uint256 _winningOut = (
            _winningShares / addressShares[_address].sumArr()
        );

        uint256 _losingSharesFrac = (
            (amountshares - shares[winningOutcome]) * 10 ** 12 / amountShares
        );

        uint256 _playerScore = (
            (2 * winningIn * _winningOut) / (_winningIn + _winningOut)
        );

        return _playerScore * _losingSharesFrac * _amountMoney;
    }

    function _priceBuyShares(
        uint outcome,
        uint256 nshares
    ) internal view returns(uint256){
        return (
            n -
            (amountShares - shares[outcome]) *
            (ln(amountShares + n) - ln(amountShares))
        );
    }

    function _PriceRequest() internal view returns(uint256){
        Chainklink.Request req = buildChainlinkRequest(
            JOB_ID,
            address(this),
            this.fulfill.selector
        );
        req.add("get", assetRequest);
        req.add("path", _assetName);
        req.add("path","usd");
        sendChainlinkRequestTo(ORACLE_ADDRESS, req, 10000000000000000);

    }

    function fulfill(bytes32 _requestId,uint265 _price) internal {
        if (_price > betValues[0]){
            winningOutcome = 0;
        } else {
            winningOutcome = 1;
        }
    }

    function _getInstanteneousPrice() internal view returns(uint256[2]){
        uint256[2] _instanteneousPrice;
        for(uint8 i = 0; i < shares.length; i++){
            _instanteneousPrice[i] = money[i] * (10 ** 18) / amountMoney;
        }
        return _instanteneousPrice;
    }

    function _validateOutcomes(uint8 outcome) internal view{
        for(uint8 i = 0; i <= shares.length; i++){
            _validate_outcome(i);
        }
    }

    function _validateOutcome(uint8 outcome) internal view{
        require(shares[outcome] > 0);
        require(instanteneousPrice[outcome] >= MIN_PRICE_SHARE * 10 ** 16);
    }
}