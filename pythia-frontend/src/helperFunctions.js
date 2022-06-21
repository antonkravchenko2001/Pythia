import Moralis from './main.js'
import {minShares, minMoney} from './config.js'

//unix to Date
export const unixToDate = (unixTimestamp) => {
    let date = new Date(parseInt(unixTimestamp) * 1000);
    return date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear();
    
};

//date to unix
export const dateToUnix = (dateStr) => {
    const date = new Date(dateStr);
    const unixTimestamp = Math.floor(date.getTime() / 1000) + 50400;
    return unixTimestamp;
}

//wei to Eth
export const weiToEth = (weiString) => {
    return parseFloat(Moralis.Units.FromWei(weiString, 18));
}

//check money
export const checkMoney = (arr) => {
    for(let i; i < arr.length; i++){
        if(parseFloat(arr[i]) < minMoney){
            console.log(`min money to buy is ${minMoney}`)
            return false;
        }
    } 
    return true;
}

//check shares
export const checkShares = (arr) => {
    for(let i; i < arr.length; i++){
        if(arr[i] < minShares){
            console.log(`min shares to buy is ${minShares}`)
            return false;
        }
    } 
    return true;
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
    } else {
        return Math.round(num * 100) / 100
    }
}