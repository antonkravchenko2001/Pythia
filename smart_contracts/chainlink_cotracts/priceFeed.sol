pragma solidity ^0.8.7;

// SPDX-License-Identifier: GPL-3.0

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumer {
    uint256 constant DENOMINATION = 10000000000;

    function getLatestPrice(address pairAddress) public view returns (uint256) {
         AggregatorV3Interface priceFeed = AggregatorV3Interface(pairAddress);
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return uint256(price) * DENOMINATION;
    }
}
