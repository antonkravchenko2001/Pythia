// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


import "./CryptoMarkets.sol";
import "./PriceFeeder.sol";
import "https://github.com/smartcontractkit/keeper/blob/master/contracts/KeeperCompatibleInterface.sol";

contract MarketsResolvedChecker is KeeperCompatibleInterface{

    event MarketResolved(bytes32 marketId);
    CryptoMarkets marketsContract;

    constructor(address marketsContractsAddress) public {
       marketsContract = CryptoMarkets(marketsContractsAddress);
    }

    function checkUpkeep(bytes calldata checkData) external view  returns (
        bool upkeepNeeded,
        bytes memory performData
    )
    {
        bytes32[30] resolvedMarketIds;
        bool upkeepNeeded;
        for(uint256 i; i < marketsContract.marketIds.length; i++){
            if(~marketsContract.markets[marketIds[i]].resolved){
                resolvedMarketIds[i] = marketIds[i];
            }
        }
        if(resolvedMarketIds){
            upkeepNeeded = true;
        }
        return (upkeepNeeded, abi.encode(resolvedMarketIds));
    }

    function performUpkeep(bytes calldata performData) external {
        bytes32[30] resolvedMarketIds = abi.decode(performData);
        for(uint256 i; i < resolvedMarkets.length; i++){

            require(~marketsContract.markets[resolvedMarkets[i]].resolved);

            PriceFeeder priceFeeder = PriceFeeder(
                marketsContract.markets[resolvedMarkets[i]].priceFeederAddress
            );

            priceFeeder.requestPrice();
            marketsContract.markets[resolvedMarkets[i]].price = (
                priceFeeder.price
            );

            marketsContract.markets[resolvedMarkets[i]].resolved = true;

            emit MarketResolved(resolvedMarkets[i]);
        }
    }

}
