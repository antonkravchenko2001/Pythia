//get market info
const _getMarketInfo = async(_marketId) => {
    const options = {
        chain: chain,
        address: marketsAddress,
        function_name: "getMarketInfo",
        abi: marketsABI,
        params: {_marketId},
    };

    try {
        let _marketInfo = await Moralis.Web3API.native.runContractFunction(
            options
        );

        let asset = await Moralis.Cloud.run(
            "getAssets",
            {priceFeed: _marketInfo[0]}
        );
        asset = asset[0];
        asset = asset.get('asset');

        let marketInfo = {
            marketId: _marketId,
            asset,
            strikePrice: weiToEth(_marketInfo[1][0]),
            resolutionPrice: weiToEth(_marketInfo[1][1]),
            wageDeadline: unixToDate(_marketInfo[2][0]),
            resolutionDate: unixToDate(_marketInfo[2][0]),
            sharesOwned: [weiToEth(_marketInfo[3][0]), weiToEth(_marketInfo[3][1])],
            moneyWaged: [weiToEth(_marketInfo[4][0]), weiToEth(_marketInfo[4][1])],
            resolved: _marketInfo[5],
            winningOutcome: parseInt(_marketInfo[6])
        }
        console.log(marketInfo);
        return marketInfo;

    } catch (error){
        console.error(error);
        return false;
    }
}
