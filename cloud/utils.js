

//unix to Date
const unixToDate = (unixTimestamp) => {
    let date = new Date(parseInt(unixTimestamp) * 1000);
    return date;
    
};
