// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "EventsEmmiter.sol";
import "MathContract.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract CryptoBet {

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
    uint8 MIN_PRICE_SHARE = 2;


    constructor(
        uint256[2] shares,
        uint256[2] money,
        uint128[2] betValues,
        uint256 resolutionDate,
        uint256 wageDeadline,
        IERC20 token,
        string assetName
    ) public {
        shares = _shares;
        money = _money;
        resolutionDate = _resolutionDate;
        wageDeadline = _wageDeadline;
        betValues = _betValues;
        token = IERC20(token_address);
        amountMoney = _total_amount_money();
        amountShares = _total_amount_shares();

        require(amountMoney >= 0);
        require(amountShares >= 0);

        instanteneousPrice = _instanteneous_price();

        _validate_outcomes();

    }

    using MathContract for uint256;

    function wageMoney(uint256[2] shares) public returns(bool){
    }

    function exchange(uint8 newoutcome) extera returns(bool){

    }

    function withdraw() public returns(bool){

    }

    function placeBet() public view returns(uint256){

    }

    function _priceBuyShares(uint outcome, uint256 nshares) internal view returns(uint256){
        return n - (amountShares - shares[outcome]) * (ln(amountShares + n) - ln(amountShares));
    }

    function _priceSellShares(uint outcome, uint256 nshares) internal view returns(uint256){
        return - n - (amountShares - shares[outcome]) * (ln(amountShares - n) - ln(amountShares));
    }

    function _validate_outcomes(uint8 outcome) internal view{
        for(uint8 i = 0; i <= shares.length, i++){
            _validate_outcome(i);
        }
    }

    function _validate_outcome(uint8 outcome) internal view{
        require(shares[outcome] > 0);
        require(instanteneousPrice[outcome] >= 2);
    }

    function _instanteneous_price() internal view returns(uint256[2]){
        uint[2] instanteneous_price;
        for(uint8 i = 0; i < shares.length; i++){
            instanteneous_price[i] = money[i] * (10 ** 18) / amountMoney;
        }
        return instanteneous_price;
    }

    function _total_amount_shares() internal view returns(uint256){
        uint256 total_amount_shares = 0;
        for(uint8 i = 0; i < shares.length; i++){
            total_amount_shares += shares[i];
        }
        return total_amount_shares;
    }

    function _total_amount_money() internal view returns(uint256){
        uint256 total_amount_money = 0;
        for(uint8 i = 0; i < money.length; i++){
            total_amount_money += money[i];
        }
        return total_amount_money;
    }