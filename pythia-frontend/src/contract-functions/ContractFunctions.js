import Moralis from '../main.js'
import {marketsAddress, marketsABI, payTokenAddress, ERC20ABI, linkTokenAddress, chain} from '../config.js'
import {unixToDate, weiToEth} from '../helperFunctions.js'


//call methods

export const _getLinkFee = async() => {
    const options = {
        chain: chain,
        address: marketsAddress,
        function_name: "getLinkFee",
        abi: marketsABI,
        params: {},
    };

    try {
        let linkFee = await Moralis.Web3API.native.runContractFunction(
            options
        );
        return linkFee;
    } catch (error){
        console.error(error);
    }
}

export const _numMarkets = async() => {
    const options = {
        chain: chain,
        address: marketsAddress,
        function_name: "getNumMarkets",
        abi: marketsABI,
        params: {},
    };

    try {
        let numMarkets = await Moralis.Web3API.native.runContractFunction(
            options
        );
        console.log(numMarkets);
        return numMarkets;
    } catch (error){
        console.error(error);
    }
}

export const _getMarketInfo = async(_marketId) => {
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
            "getAsset",
            {priceFeed: _marketInfo[0]}
        );
        console.log(asset);
        asset = asset.get('asset');

        let marketInfo = {
            marketId: _marketId,
            asset,
            strikePrice: weiToEth(_marketInfo[1][0]),
            resolvePrice: weiToEth(_marketInfo[1][1]),
            wageDeadline: unixToDate(_marketInfo[2][0]),
            resolveDate: unixToDate(_marketInfo[2][0]),
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

export const _getPlayerInfo = async(_player, _marketId) => {
    const options = {
        chain: chain,
        address: marketsAddress,
        function_name: "getPlayerInfo",
        abi: marketsABI,
        params: {
            _player,
            _marketId
        },
    };

    try {
        let _playerInfo = await Moralis.Web3API.native.runContractFunction(
            options
        );
        const playerInfo = {
            sharesOwned: [weiToEth(_playerInfo[0][0]), weiToEth(_playerInfo[0][1])],
            moneyWaged: [weiToEth(_playerInfo[1][0]), weiToEth(_playerInfo[1][1])],
            reward: weiToEth(_playerInfo[2]),
            expertScore: weiToEth(_playerInfo[3]),
            withdrawed: _playerInfo[4]
        };
        console.log(playerInfo);
        return playerInfo;
    } catch (error){
        console.error(error);
        return false;
    }
}

export const _numSharesForPrice = async(params) => {
    const options = {
        chain: chain,
        address: marketsAddress,
        function_name: "numSharesForPrice",
        abi: marketsABI,
        params
    };

    try {
        let numShares = await Moralis.Web3API.native.runContractFunction(
            options
        );
        return numShares;
    } catch (error){
        console.error(error);
    }
}


export const _getExpertScore = async(_player, _marketId) => {
    let options = {
        chain: chain,
        address: marketsAddress,
        function_name: "_calcExpertScore",
        abi: marketsABI,
        params: {
            _marketId,
            _playerAddress: _player
        },
    }

    const _expertScore = await Moralis.Web3API.native.runContractFunction(
        options
    );

    console.log(_expertScore);
    return weiToEth(_expertScore);

}


//send methods

export const _approveLinkTransfer = async(_amount) => {
    await Moralis.enableWeb3();
    let options = {
        chain: chain,
        contractAddress: linkTokenAddress,
        functionName: "approve",
        abi: ERC20ABI,
        params: {
            spender: marketsAddress,
            amount: _amount
        },
    };
    try{
        await Moralis.executeFunction(options);
        console.log(`approved ${_amount} of link`)
    } catch(error) {
        console.error(error);
    }
}

export const _approvePayTokenTransfer = async(_amount) => {
    await Moralis.enableWeb3();
    let options = {
        chain: chain,
        contractAddress: payTokenAddress,
        functionName: "approve",
        abi: ERC20ABI,
        params: {
            spender: marketsAddress,
            amount: _amount
        },
    };
    try{
        await Moralis.executeFunction(options);
        console.log(`approved ${_amount} of token`)
    } catch(error) {
        console.error(error);
    }
}


export const _createMarket = async(params) =>  {
    const linkFee =  await _getLinkFee();
    const amount =  params._moneyWaged.reduce(
        (acc, curr) => {return acc + curr;}
    );
    await _approveLinkTransfer(linkFee);
    await _approvePayTokenTransfer(amount);

    let options = {
        chain: chain,
        contractAddress: marketsAddress,
        functionName: "createMarket",
        abi: marketsABI,
        params: params
    };
    try{
        await Moralis.executeFunction(options);
        console.log('market created')
    } catch(error){
        console.error(error);
    }

}

export let _wageMoney = async(params) =>  {
    const options = {
        chain: chain,
        contractAddress: marketsAddress,
        functionName: "wageMoney",
        abi: marketsABI,
        params: params
    };
    const amount = options.params._moneyToWage.reduce(
        (acc, curr) => {return acc + curr;}
    );
    await _approvePayTokenTransfer(amount);
    try{
        await Moralis.executeFunction(options);
        console.log('money waged');
    } catch(error){
        console.error(error);
    }
}

export let marketCreated = async() =>{
    const options = {
        chain: chain,
        abi: marketsABI,
        contractAddress: marketsAddress,
        topic: 'MarketCreated',
    }
    try{
        const event = await Moralis.Web3API.native.getContractEvents(options);
        console.log(event);
        return event;
    } catch(error){
        console.error(error);
    }
}

export let deposited = async() =>{
    const options = {
        chain: chain,
        abi: marketsABI,
        contractAddress: marketsAddress,
        topic: 'Deposited',
    }
    try{
        const event = await Moralis.Web3API.native.getContractEvents(options);
        console.log(event);
        return event;
    } catch(error){
        console.error(error);
    }
}

export let withdrawed = async() =>{
    const options = {
        chain: chain,
        abi: marketsABI,
        contractAddress: marketsAddress,
        topic: 'Withdrawed'
    }
    try{
        const event = await Moralis.Web3API.native.getContractEvents(options);
        console.log(event);
        return event;
    } catch(error){
        console.error(error);
    }
}