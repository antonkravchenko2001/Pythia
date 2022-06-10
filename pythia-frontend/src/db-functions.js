import Moralis from './main.js'

export const saveCreatedMarket = async(params) => {
    const Market = Moralis.Object.extend('Markets');
    const market = new Market();

    market.set('marketId', params.marketId);
    market.set('asset', params.asset);
    market.set('strikePrice', params.strikePrice);
    market.set('wageDeadline', params.wageDeadline);
    market.set('resolveDate', params.resolveDate);
    market.set('description', params.description);
    market.set('volume', params.volume);
    market.set('volumeShares', params.volumeShares);
    console.log('properties set')
    try{
        await market.save();
    } catch(error){
        console.error(error);
    }
}

export const requestAssetFeed = async(assetName) => {
    let asset = assetName.replace( /\s/g, '').toLowerCase();
    let assetFeed = await Moralis.Cloud.run('getAsset', {asset});
    if(assetFeed){
        assetFeed = assetFeed[0].get('priceFeed');
        console.log(assetFeed);
        return assetFeed;
    }
    return null;
}


export const requestAssetName = async(priceFeed) => {
    let assetName =  await Moralis.Cloud.run('getAssetName', {priceFeed});
    if(assetName){
        return assetName[0].get('asset');
    }
    return null;
}







