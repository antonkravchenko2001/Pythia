
// saving market
Moralis.Cloud.define("saveMarket",  async(request) => {

    const query = new Moralis.Query('Markets');

    //filter data
    const filters = request.params.filters;
    let market = null;

    //check that filters are not empty
    if(filters != null){
        for(const filter in filters){
            query.equalTo(filter, filters[filter]);
        }

        //query result
        market = await query.first();
        logger.info(`this is market: ${market === null}`)
    }

    //if market is null 
    if(!market){
        const Market = Moralis.Object.extend('Markets');
        market = new Market();
    }

    //set values
    const values = request.params.values;

    for(const key in values){
        market.set(key, values[key]);
    }

    //save market
    await market.save();

    logger.info('market saved');
});

//query Markets
Moralis.Cloud.define("getMarkets", async(request) => {
    const query = new Moralis.Query("Markets");

    //defined filter columns
    const filters = request.params.filters;

    logger.info('filters',filters);

    //filter datas
    if(filters){
        if(filters['asset'] !== 'All'){
            query.equalTo('asset', filters['asset'].toLowerCase());
        }
        if(filters['volume'] !== 'All'){
            query.greaterThan('volume', filters['volume']);
        }
        if(filters['wageDeadline'] !== 'All'){
            query.lessThan('wageDeadline', filters['wageDeadline']);
        }
    }

    //sort data by volume
    query.descending("volume");


    query.limit(25);

    //return results
    const markets = await query.find();
    return markets;
});

//save player
Moralis.Cloud.define('savePlayer', async(request) => {
    const query = new Moralis.Query('Players');

    //filter data
    const filters = request.params.filters;
    let player = null;

    //check that filters are not empty
    if(filters){
        for(const filter in filters){
            query.equalTo(filter, filters[filter]);
        }

        //query result
        player = await query.first();
    }

    //if player is null 
    if(!player){
        const Player = Moralis.Object.extend('Players');
        player = new Player();
    }

    //set values
    const values = request.params.values;

    for(const key in values){
        player.set(key, values[key]);
    }
    logger.info('player');
    logger.info(player);
    //save player
    await player.save();

    logger.info('player saved');
});


//query Markets
Moralis.Cloud.define("getPlayers", async(request) => {
    const query = new Moralis.Query("Players");

    //defined filter columns
    const filters = request.params.filters;

    //filter data
    for(const filter in filters){
        query.equalTo(filter, filters[filter]);
    }

    query.limit(20);

    //return results
    const players = await query.find();
    return players;
});

//query assets
Moralis.Cloud.define("getAssets", async (request) => {
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
    const results = await query.find();
    if(results){
        return results;
    }
    return null;
});


//query top performers
Moralis.Cloud.define(
    'getTopPerformers',
    async (request) => {
        const query = new Moralis.Query('Players');
        const pipeline = [
            {
                group: {
                    objectId: "$player",
                    reward: {$sum: "$reward" },
                    expertScore: {$sum: '$expertScore'}
                },
            },
            {
                sort: {
                    expertScore: -1,
                    reward: -1
                }
            }
        ];
        results = await query.aggregate(pipeline, { useMasterKey: true });
        return results;
    }
)