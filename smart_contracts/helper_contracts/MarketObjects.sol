// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../chainlink_contracts/PriceFeeder.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract MarketObjects {

    struct Player{
        uint256[2] moneyWaged;
        uint256[2] sharesOwned;
        uint256 reward;
        uint256 expertScore;
        bool withdrawed;
    }

    // bet struct
    struct Market{
        //mapping(address => player) players of the market
        mapping(address => Player) players;
        //total amount of shares owned for each outcome
        uint256[2] sharesOwned;
        //total amount of money waged for each outcome
        uint256[2] moneyWaged;
        //the asset name
        uint256 assetName;
        //value to compare the price of the asset with to determine the outcome
        uint256 benchPrice;
        //resolution price;
        uint256 resolutionPrice;
        //winning outcome
        uint256 winningOutcome;
        //Resolution date
        uint256 resolutionDate;
        // The last date to wage money on a bet
        uint256 wageDeadline;
        //resolved flag
        bool resolved;
        //pay token contract
        IERC20 payToken;
        //price feeder contract
        PriceFeeder priceFeeder;
    }

}