import Moralis from '../main.js'

export let saveMarket = async(params) => {
    const Market = Moralis.Object.extend('Markets');
    const market = new Market();
    market.set('MarketId', params.marketId);
    market.set('MarketName', params.marketName);
    market.set('MarketDescription', params.marketDescription);
    await market.save();
}