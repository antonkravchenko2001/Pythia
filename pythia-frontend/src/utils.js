import Moralis from './main.js'
import { chainId } from './config.js';

//getting chain
export const checkChain = async () => {
    if(!Moralis.web3){
        await Moralis.enableWeb3();
    }
    console.log(Moralis.web3.provider.chainId);
    return Moralis.web3.provider.chainId === chainId;
}

//unix to Date
export const unixToDate = (unixTimestamp) => {
    let date = new Date(parseInt(unixTimestamp) * 1000);
    return date;
    
};

export const dateToStr = (date) => {
    date = new Date(date);
    return (
        date.getDate().toString() +
        '/' +
        (date.getMonth() + 1).toString() +
        '/' +
        date.getFullYear().toString()
    );
}

//date to unix
export const dateToUnix = (date=null) => {
    let unixTimestamp;
    if(date===null){
        date = new Date();
        unixTimestamp = Math.floor(date.getTime() / 1000);
    }else {
        date = new Date(Date.parse(date));
        date.setUTCHours(12,0,0,0);
        unixTimestamp = Math.floor(date.getTime() / 1000);
    }
    return unixTimestamp;
}

//wei to Eth
export const weiToEth = (weiString) => {
    return parseFloat(Moralis.Units.FromWei(weiString, 18));
}

//transform from eth to wei denomination
export const ethToWei = (arr) => {
    const res = [...arr];
    for(let i = 0; i < res.length; i++){
        res[i] = Moralis.Units.ETH(`${res[i]}`);
    }
    return res
}

//round number
export const roundNum = (num) => {
    if(num >= 100){
        return Math.round(num);
    } else if(num >= 10){
        return Math.round(num * 10) / 10
    } else if(num >= 0.1) {
        return Math.round(num * 100) / 100
    } else {
        return Math.round(num * 1000) / 1000
    }
}

export const determineExpertise = async (player) => {
    const results = await Moralis.Cloud.run(
        'getTopPerformers',
        player
    )
    if(!results[0]){
        return 'Novice';
    }
    const expertScore = results[0].expertScore;
    if(expertScore < 100){
        return 'Novice';
    }else if(expertScore < 1000){
        return 'Investor'
    }else if(expertScore < 10000){
        return 'Expert'
    }else{
        return 'Crypto grandmaster'
    }


}