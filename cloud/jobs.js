Moralis.Cloud.job("updMarketStatus", (request) =>  {
    const run  = async() => await Moralis.Cloud.run('updateMarketStatus', {});
    return run();
});