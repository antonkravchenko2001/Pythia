
// saving market
Moralis.Cloud.define("saveMarket",  async(request) => {
    const Market = Moralis.Object.extend('Markets');
    const market = new Market();

    const features = request.params;

    for(const feat in features){
        market.set(feat, features[feat]);
    }

    logger.info('data saved');

    //save market
    await market.save();
});

//query Markets
Moralis.Cloud.define("getMarkets", async(request) => {
    const query = new Moralis.Query("Markets");

    //defined filter columns
    const filters = request.params.filters;

    //filter data
    for(const filter in filters){
        query.equalTo(filter, filters[filter]);
    }

    //sort data by volume
    query.descending("volume");


    query.limit(20);

    //return results
    const markets = await query.find();
    return markets;
});

//update market
Moralis.Cloud.define('setMarket', async(request) => {
    const query = new Moralis.Query('Markets');

    //filter data
    const filters = request.params.filters;
    for(const filter in filters){
        query.equalTo(filter, filters[filter]);
    }

    //query result
    const market = await query.first();

    //updated values
    const vals = request.params.values;
    for(const val in  vals){
        market.set(val, vals[val]);
    }

    //save update
    await market.save();
});

//query assets
Moralis.Cloud.define("getAsset", async (request) => {
    const query = new Moralis.Query('Assets');
    const filters = request.params;
    let value = null;
    for (const item in filters) {
        value = filters[item]
        if(item === 'asset'){
            value = value.toLowerCase().replace(/\s/g, '');
        }
        logger.info(value);
        query.equalTo(item, value);
    }
    const results = await query.first();
    if(results){
        return results;
    }
    return null;
});
