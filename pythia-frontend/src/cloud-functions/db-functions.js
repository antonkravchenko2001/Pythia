import Moralis from '../main.js'

let saveCreatedMarket = async(params) => {
    const Market = Moralis.Object.extend('Markets');
    const market = new Market();
    market.set('MarketId', params.marketId);
    market.set('MarketName', params.marketName);
    market.set('MarketDescription', params.marketDescription);
    market.set('TotalMoneyWaged', params.totalMoneyWaged);
    await market.save();
}

export default saveCreatedMarket;







