//wei to Eth
const weiToEth = (weiString) => {
    return parseFloat(Moralis.Units.FromWei(weiString, 18));
}

//unix to Date
const unixToDate = (unixTimestamp) => {
    let date = new Date(parseInt(unixTimestamp) * 1000);
    return date;
    
};
