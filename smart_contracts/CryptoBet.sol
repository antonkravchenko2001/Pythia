// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "./EventsEmitter.sol";
import "./MathContract.sol";
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
        EventsEmitter emitter = EventsEmitter();
        _validate_outcomes();

    }

    using MathContract for uint256;

    function wageMoney(uint256[2] buyShares) public returns(bool){
        uint256 total_price = 0;
        uint256 num_shares = 0;
        uint[2] money_waged;

        for(uint8 i = 0; i < numShares.length; i++){
            total_price += _priceBuyShares(i, numShares[i]);
            num_shares += buyShares[i];
        }

        require(token.balanceOf(msg.sender) >= total_price);

        for(uint8 i; i < numShares.length; i++){
            require(
               (shares[i] + buyShares[i]) * (10 ** 18) / (amountShares + buyShares[i]) >=
               MIN_PRICE_SHARE * 10 ** 16
            );
        }

        for(uint8 i; i < numShares.length; i++){
            shares[i] += buyShares[i];
            instanteneousPrice += (shares[i] + buyShares[i]) * (10 ** 18) / (amountShares + buyShares[i]);
            money_waged[i] = _priceBuyShares(i, buyShares[i]);
            money[i] += money_waged[i];
            for(uint8 j; j < numShares.length; j++){
                addressMoney[msg.sender][j] += money_waged[i];
                addressShares[msg.sender][j] += buyShares[j];
            }
        }

        token.transferFrom(msg.sender, this.address, total_price);
        emitter.EmitDeposit(msg.sender, this.address, buyShares, money_waged);
    }

    function withdraw(uint256[2] shares) public returns(bool){
        require (msg.sender == owner, "only owner can withdraw funds");
        require(_resolutionDate >= block.timestamp);
        uint _rewardAmount = (money - money[winningOutcome]) * addressShares[msg.sender][winningOutcome] / shares[winningOutcome];
        _rewardAmount += addressMoney[msg.sender][winningOutcome];
        uint expertScore = calcExpertScore(msg.sender);
        token.transfer(msg.sender, _rewardAmount);
        addressShares[msg.sender][winningOutcome] = 0;
        addressMoney[msg.sender][winningOutcome] = 0;

        emitter.EmitWithdraw(msg.sender,this.address, _rewardAmount, expertScore);
    }

    function calcExpertScore(address _address) internal view returns (uint) {
        uint expertScore = expertScore * amountMoney;
        uint winningShares = addressShares[_address][winningOutcome] * 10 ** 6;
        uint winningIn = winningShares / shares[winningOutcome];
        uint sumShares = 0;

        for (i = 0; i <= shares.length; i++) {
            sumShares += addressShares[_address][i];
        }

        uint winningOut = winningShares / sumShares;
        uint losingSharesTotal = (amountshares - shares[winningOutcome]) * 10 ** 12 / amountShares;
        uint harmonicMean = (2 * winningIn * winningOut) / (winningIn + winningOut);

        return expertScore * harmonicMean * losingSharesTotal;

    }


    function _priceBuyShares(uint outcome, uint256 nshares) internal view returns(uint256){
        return n - (amountShares - shares[outcome]) * (ln(amountShares + n) - ln(amountShares));
    }

    function _validate_outcomes(uint8 outcome) internal view{
        for(uint8 i = 0; i <= shares.length; i++){
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
}