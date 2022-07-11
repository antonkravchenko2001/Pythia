
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
    const query = new Moralis.Query('Deposits');
    let m = {};
    if(request.params.asset && (request.params.asset != 'All')){
        m.asset = request.params.asset.toLowerCase();
    }
    if(request.params.tvl && (request.params.tvl != 'All')){
        m.tvl = {
            $gt: request.params.tvl
        };
    }if(request.params.wageDeadline && (request.params.wageDeadline != 'All')){
        m.wageDeadline = {
            $lt: request.params.wageDeadline
        };
    }

    // const filters = request.params;
    const pipeline = [
        {
            lookup: {
              from: "Markets",
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
                'objectId': '$marketId',
                'marketId': {
                    $max: '$marketId'
                },
                'strikePrice': {
                    $max: '$deposits.strikePrice'
                },
                'tvl': {
                    $sum: {
                        $add: ['$moneyYes', '$moneyNo']
                    }
                },
                'asset': {
                    $max: '$deposits.asset'
                },
                'resolved': {
                    $max: '$deposits.resolved'
                },
                'resolutionDate': {
                    $max: '$deposits.resolutionDate'
                },
                'wageDeadline': {
                    $max: '$deposits.wageDeadline'
                },
            }
        },
        {
            sort: {
              tvl: -1
            }
        }
    ];

    if(m !== {}){
        pipeline.push(
            {match: m}
        );
    }

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
        const query = new Moralis.Query('Withdrawals');
        const pipeline = [

            {
                lookup: {
                    from: "Deposits",
                    localField: "player",
                    foreignField: "player",
                    as: "player",
                },
            },
            {
                project: {
                    player: 1,
                    totalMoneyWaged: {$add: ['$moneyYes', '$moneyNo']},
                    reward: 1,
                    expertScore: 1
                }
            },
            {
                group: {
                    objectId: "$player",
                    totalMoneyWaged: {$sum: '$totalMoneyWaged'},
                    reward: {$sum: '$reward'},
                    expertScore: {$sum: '$expertScore'}
                },
            },
            {
                sort: {
                    expertScore: -1,
                    reward: -1,
                    totalMoneyWaged: 1
                }
            }
        ];
        const results = await query.aggregate(pipeline, { useMasterKey: true });
        return results;
    }
)
