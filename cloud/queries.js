
// saving market
Moralis.Cloud.define("saveMarket",  async(request) => {
    //intialize query and player objects
    const Market = Moralis.Object.extend('Markets');
    const query = new Moralis.Query('Markets');

    //filter data
    const params = request.params;
    query.equalTo('marketId', params.marketId);
    let market = await query.first();
    if(!market){
        market = new Market();
        market.set('marketId', params.marketId);
    }

    //set values
    const values = request.params.values;

    for(const key in values){
        market.set(key, values[key]);
    }

    //save market
    await market.save();
});


//get market info
Moralis.Cloud.define('getMarketstatus', async(request) => {
    const _marketId = request.params._marketId;
    const options = {
        chain: chain,
        address: marketsAddress,
        function_name: "getMarketInfo",
        abi: marketsABI,
        params: {_marketId},
    };
    let _marketInfo = await Moralis.Web3API.native.runContractFunction(
        options
    )

    let asset = await Moralis.Cloud.run(
        "getAssets",
        {priceFeed: _marketInfo[0]}
    );
    asset = asset[0];
    asset = asset.get('asset');

    let marketInfo = {
        marketId: _marketId,
        resolved: _marketInfo[5],
        winningOutcome: parseInt(_marketInfo[6])
    }
    return marketInfo;
}
)


Moralis.Cloud.define(
    '_updateMarketStatus',
    async(request) => {
        const query = new Moralis.Query('Markets');
        const today = new Date();
        today.setUTCHours(12,0,0,0);
        query.equalTo('resolutionDate', today);
        logger.info(today);
        let markets = await query.find();

        let marketInfo;
        let res = [];
        let market;
    
        for(let i = 0; i < markets.length; i++){
            market = markets[i];
            marketInfo = await Moralis.Cloud.run(
                'getMarketstatus',
                {_marketId: market.get('marketId')}
            )
            market.set('resolved', marketInfo.resolved);
            market.set('winningOutcome', marketInfo.winningOutcome);
            await market.save();
        }
    }
)

Moralis.Cloud.define(
    'checkMarketExistence',
    async(request) => {
        //intialize query and player objects
        const query = new Moralis.Query('Markets');

        //filter data
        const params = request.params;
        query.equalTo('marketId', params.marketId);
        let market = await query.first();
        if(!market){
            return false;
        }
        return true;
    }
)

//query Markets
Moralis.Cloud.define("getMarkets", async(request) => {
    const query = new Moralis.Query('Markets');
    if(request.params.creator){
        logger.info('creator');
        logger.info(request.params.creator);
        query.equalTo("creator", request.params.creator);
    }
    if(request.params.description || (!request.params.description === '')){
        query.matches('description', request.params.description);
    }

    const pipeline = [
        {
            lookup: {
            from: "Deposits",
            localField: "marketId",
            foreignField: "marketId",
            as: "deposits",
            },
        },
        {
            unwind: {
            path: "$deposits"
            }
        },
        {
            group: {
                'objectId': '$deposits.marketId',
                'marketId': {
                    $max: '$deposits.marketId'
                },
                'strikePrice': {
                    $max: '$strikePrice'
                },
                'tvl': {
                    $sum: {
                        $add: ['$deposits.moneyYes', '$deposits.moneyNo']
                    }
                },
                'asset': {
                    $max: '$asset'
                },
                'resolved': {
                    $max: '$resolved'
                },
                'resolutionDate': {
                    $max: '$resolutionDate'
                },
                'wageDeadline': {
                    $max: '$wageDeadline'
                },
            }
        },
        {
            sort: {
                resolved: 1,
                tvl: -1,
                resolutionDate: -1,
                resolutionDate: -1
            }
        }
    ];

    const results = await query.aggregate(pipeline, { useMasterKey: true });
    return results;
});

//save deposit
Moralis.Cloud.define('deposit', async(request) => {

    const Deposit = Moralis.Object.extend('Deposits');

    let deposit = new Deposit();
    const params = request.params;
    deposit.set('marketId', params.marketId);
    deposit.set('player', params.player);
    deposit.set('moneyYes', params.moneyYes);
    deposit.set('moneyNo', params.moneyNo);
    deposit.set('sharesNo', params.sharesNo);
    deposit.set('sharesYes', params.sharesYes);

    await deposit.save();
});

//save withrawal
Moralis.Cloud.define(
    'withdraw',
    async (request) => {
        const Withdrawal = Moralis.Object.extend('Withdrawals');
        let deposit = new Withdrawal();
        const params = request.params;
        deposit.set('marketId', params.marketId);
        deposit.set('player', params.player);
        deposit.set('expertScore', params.expertScore);
        deposit.set('reward', params.reward);
        await deposit.save();
    }
)


//query top performers
Moralis.Cloud.define(
    'getTopPerformers',
    async (request) => {
        const query = new Moralis.Query('Deposits');
        const pipeline = [
            {
                group: 
                {
                    objectId: {
                        'player': '$player',
                        'marketId': '$marketId'
                    },
                    totalMoneyWaged: {
                        $sum: {
                            $add: ['$moneyYes', '$moneyNo']
                        }
                    }
                },
            },
            {
                group: 
                {
                    objectId: {
                        'player': '$_id.player'
                    },
                    totalMoneyWaged: {
                        $sum: '$totalMoneyWaged'
                    },
                    numMarkets: {
                        $sum: 1
                    }
                },
            },
            {
                lookup: {
                    from: "Withdrawals",
                    localField: "_id.player",
                    foreignField: "player",
                    as: "player",
                },
            },
            {
                unwind: {
                  path: "$player"
                }
            },
            {
                group: 
                {
                    objectId: {
                        'player': '$_id.player'
                    },
                    player: {
                        $max: '$player.player'
                    },
                    totalMoneyWaged: {
                        $max: '$totalMoneyWaged'
                    },
                    numMarkets: {
                        $max: '$numMarkets'
                    },
                    expertScore: {
                        $sum: '$player.expertScore'
                    },
                    reward: {
                        $sum: '$player.reward'
                    }
                },
            },
            {
                project:{
                    player: '$player',
                    numMarkets: '$numMarkets',
                    totalMoneyWaged: '$totalMoneyWaged',
                    reward: '$reward',
                    expertScore: '$expertScore'
                }
            },
            {
                sort: {
                    expertScore: -1,
                    reward: -1,
                    totalMoneyWaged: 1
                }
            }
        ];
        let m  = {};
        if(request.params.player){
            m.player = {
                $eq: request.params.player
            }
            pipeline.push(m);
        }

        const results = await query.aggregate(pipeline, { useMasterKey: true });
        return results;
    }
);

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
