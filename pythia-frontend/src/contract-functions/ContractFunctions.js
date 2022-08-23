import Moralis from '../main.js'
import {marketsAddress, marketsABI, payTokenAddress, ERC20ABI, chain} from '../config.js'
import {unixToDate, weiToEth, roundNum, ethToWei} from '../utils.js'


//call methods

const executeTransaction = async(options) => {
    let tx = await Moralis.executeFunction(options);
    await tx.wait();
}

export const _allowance = async(owner) => {
    let options = {
        chain: chain,
        address: payTokenAddress,
        function_name: "allowance",
        abi: ERC20ABI,
        params: {
            owner,
            spender: marketsAddress
        },
    };
    try {
        let allowance = await Moralis.Web3API.native.runContractFunction(
            options
        );
        return allowance;
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
        return numMarkets.toString();
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

        console.log(_marketInfo);

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
            resolutionDate: unixToDate(_marketInfo[2][1]),
            sharesOwned: [weiToEth(_marketInfo[3][0]), weiToEth(_marketInfo[3][1])],
            moneyWaged: [weiToEth(_marketInfo[4][0]), weiToEth(_marketInfo[4][1])],
            resolved: _marketInfo[5],
            winningOutcome: parseInt(_marketInfo[6])
        }
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
        numShares = roundNum(weiToEth(numShares));
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
    try{
        const _expertScore = await Moralis.Web3API.native.runContractFunction(
            options
        );
        return weiToEth(_expertScore);
    }catch(error){
        console.error(error);
    }

}

export const _getReward = async(_player, _marketId) => {
    let options = {
        chain: chain,
        address: marketsAddress,
        function_name: "_calcReward",
        abi: marketsABI,
        params: {
            _marketId,
            _playerAddress: _player
        },
    }

    try{
        const _reward = await Moralis.Web3API.native.runContractFunction(
            options
        );
        return weiToEth(_reward);
    }catch(error){
        console.error('could not compute reward')
        return 0;
    }

}


//send methods

export const _approvePayTokenTransfer = async(amount) => {
    //get _amount to pay
    const owner = Moralis.User.current().get('ethAddress');
    let allowance = await _allowance(owner, marketsAddress);
    amount = weiToEth(amount);
    allowance = weiToEth(allowance);
    if(allowance < amount){
        let options = {
            chain: chain,
            contractAddress: payTokenAddress,
            functionName: "approve",
            abi: ERC20ABI,
            params: {
                spender: marketsAddress,
                amount: ethToWei([amount])[0]
            },
        };
        try{
            await executeTransaction(options);
            return true;
        } catch(error) {
            console.error(error);
            return false;
        }
    }
    return true;

}


export const _createMarket = async(params) =>  {
    const amount =  ethToWei(
        [
            weiToEth(params._moneyWaged[0]) + weiToEth(params._moneyWaged[1])
        ]
    )[0]
    let approvalStatus = await _approvePayTokenTransfer(amount);
    console.log('status', approvalStatus);
    if(approvalStatus){
        let options = {
            chain: chain,
            contractAddress: marketsAddress,
            functionName: "createMarket",
            abi: marketsABI,
            params: params
        };
        try{
            await executeTransaction(options);
            return true;
        }catch(error){
            console.error(error);
            return false;
        }
    }
    return false;
}

export let _wageMoney = async(params) =>  {
    const options = {
        chain: chain,
        contractAddress: marketsAddress,
        functionName: "wageMoney",
        abi: marketsABI,
        params: params
    };
    const amount =  ethToWei(
        [
            weiToEth(params._moneyToWage[0]) + weiToEth(params._moneyToWage[1])
        ]
    )[0]
    let approvalStatus = await _approvePayTokenTransfer(amount);
    if(approvalStatus){
        try{
            await executeTransaction(options);
            return true;
        } catch(error){
            console.error(error);
            return false;
        }
    }
    return false;
}

export let _withdrawWinnings = async(_marketId) =>  {
    const options = {
        chain: chain,
        contractAddress: marketsAddress,
        functionName: "withdraw",
        abi: marketsABI,
        params: {_marketId}
    };
    try{
        await executeTransaction(options);
        return true;
    }catch(error){
        console.error(error);
        return false;
    }
}