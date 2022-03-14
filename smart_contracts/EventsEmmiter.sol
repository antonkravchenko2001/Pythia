// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract EventsEmmiter{

    event Deposit(
        address indexed player,
        address indexed bet,
        uint256[] shares,
        uint256[] money_waged
    );

    event Withdraw(
        address indexed player,
        address indexed bet,
        uint256 amount
    );

    function EmitDeposit(
        address player,
        address bet,
        uint256[] calldata shares,
        uint256[] calldata money_waged
    ) external returns(bool) {
        emit Deposit(player, bet, shares, money_waged);
        return true;
    }

    function EmitWithdraw(
        address player,
        address bet,
        uint256 amount
    ) external returns(bool) {
        emit Withdraw(player, bet, amount);
        return true;
    }


}
