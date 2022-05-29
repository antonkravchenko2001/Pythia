import Moralis from '../main.js';
import {marketsAddress, marketsABI, payTokenAddress, ERC20ABI, linkTokenAddress, chain} from '../config.js'

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
        console.log(linkFee)
        return linkFee;
    } catch (error){
        console.error(error);
    }
}

export const _numMarkets = async() => {
    const options = {
        chain: chain,
        address: marketsAddress,
        function_name: "getLinkFee",
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
        let marketInfo = await Moralis.Web3API.native.runContractFunction(
            options
        );
        console.log(marketInfo);
        return marketInfo;
    } catch (error){
        console.error(error);
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
        let playerInfo = await Moralis.Web3API.native.runContractFunction(
            options
        );
        console.log(playerInfo);
        return playerInfo;
    } catch (error){
        console.error(error);
    }
}

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
        console.log(`approved ${_amount}`)
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
        console.log(`approved ${_amount}`)
    } catch(error) {
        console.error(error);
    }
}


export const _createMarket = async(params) =>  {
    const linkFee =  await _getLinkFee();
    const amount =  params._sharesOwned.reduce(
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