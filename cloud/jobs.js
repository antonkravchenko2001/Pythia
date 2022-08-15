Moralis.Cloud.job("updateMarketStatus", (request) =>  {
    const run  = async() => await Moralis.Cloud.run('_updateMarketStatus', {});
    return run();
});