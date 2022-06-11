import Moralis from './main.js'

export const unixToDate = (unixTimestamp) => {
    let date = new Date(parseInt(unixTimestamp) * 1000);
    return date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear();
    
};

export const dateToUnix = (dateStr) => {
    const date = new Date(dateStr);
    const unixTimestamp = Math.floor(date.getTime() / 1000) + 50400;
    return unixTimestamp;
}

const toScientific = (num) => {
    if(Math.abs(num) <= 1e-5){
        return num.toExponential();
    }
    return num;
}

const fromScientific = (num) => {
    return Number(num.toString());
}


export const ethToWei = (num) => {
    return Moralis.Units.ETH(
        `${fromScientific(num)}`
    );
}

export const weiToEth = (weiString) => {
    return parseFloat(
        toScientific(
            parseFloat(
                Moralis.Units.FromWei(weiString, 18)
        )
    ));
}