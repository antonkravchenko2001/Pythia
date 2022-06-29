<template>
    <div class="container-around">
        <div v-if='marketData.marketInfo' class="market-info-space">
            <MarketInfo v-bind:marketData='marketData'/>
            <div class="state-and-buy-container">
                <MarketState v-bind:marketData='marketData'/>
                <BuyShares v-bind:marketData='marketData'/>
            </div>
        </div>
    </div>
</template>

<script>
import MarketInfo from './subcomponents/MarketInfo.vue'
import BuyShares from './subcomponents/BuyShares.vue'
import MarketState from './subcomponents/MarketState.vue'
import {_getMarketInfo, _getPlayerInfo, _getReward, _getExpertScore} from '../contract-functions/ContractFunctions.js'
import Moralis from '../main.js'
export default {
    components: {
        MarketInfo,
        BuyShares,
        MarketState
    },
    data(){
        return {
            marketData : {
                withDrawInfo : null,
                marketInfo: null,
                playerInfo: null
            }
        }
    },
    methods: {
        //load market info
        async loadMarket(marketId){
            let marketInfo = await _getMarketInfo(marketId);
            const volume = marketInfo
                           .moneyWaged
                           .reduce(
                                    (acc, curr) => { return acc + curr; }
                            );
            const volumeShares = marketInfo
                           .sharesOwned
                           .reduce(
                                    (acc, curr) => { return acc + curr; }
                            );
            const resolvePrice = marketInfo.resolvePrice;

            const resolved = marketInfo.resolved;

            const winningOutcome = marketInfo.winningOutcome;

            //if volume is 0 then market is not created
            if(volume == 0){
                return null;
            }


            //save market
            const marketValues = {
                resolvePrice,
                volume,
                volumeShares,
                resolved,
                winningOutcome
            }

            await Moralis.Cloud.run(
                'saveMarket', {
                    filters: {marketId},
                    values: marketValues
                }
            );
            
            //get description from database
            let info = await Moralis.Cloud.run(
                'getMarkets',
                {
                    filters: {marketId},
                    values: marketValues
                },

            );

            marketInfo['description'] = info[0].get('description');
            return marketInfo;
        },

        //load player info
        async loadPlayer(player, marketId){

            let playerInfo = await _getPlayerInfo(player, marketId);
            playerInfo['player'] = player;
            playerInfo['marketId'] = marketId;

            //update market
            const playerValues = {
                sharesOwned: playerInfo.sharesOwned,
                moneyWaged: playerInfo.moneyWaged, 
                reward: playerInfo.reward,
                expertScore: playerInfo.expertScore,
                withdrawed: playerInfo.withdrawed
            }

            console.log('player info')
            console.log(playerValues);

            await Moralis.Cloud.run(
                'savePlayer', {
                    filters: {
                        marketId,
                        player
                    },
                    values: playerValues
                }
            );

            return playerInfo;

        },

        //load withdraw info
        async loadWithdrawStats(player, marketId){
            const reward = await _getReward(player, marketId);
            const expertScore = await _getExpertScore(player, marketId);
            return {
                reward,
                expertScore
            };
        }
    },
    async created() {
        const marketId = this
                        .$route
                        .params
                        .marketId
                        .toString();
        const marketInfo = await this.loadMarket(marketId);
        this.marketData.marketInfo = marketInfo;

        const player = this
                       .$store
                       .state
                       .user
                       .get('ethAddress');
        if(player !== null){
            const playerInfo = await this.loadPlayer(player, marketId);
            this.marketData.playerInfo = playerInfo

            if(marketInfo.resolved){
                const withDrawInfo = await this.loadWithdrawStats(player, marketId);
                this.marketData.withDrawInfo = withDrawInfo;
            }
        }

        console.log(this.marketData)

    }



}
</script>

<style scoped>
    .container-around {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        font-family: 'Montserrat';
        font-weight: 400;
    }
    .market-info-space {
        font-size: 13px;
        display: grid;
        gap: 50px;
        grid-template-columns: 5fr 3fr;
        background-color: #0b1723;
        padding: 20px;
        box-shadow: 1px 1px 8px #121212;
    }

    .state-and-buy-container {
        display: grid;
        grid-template-rows: 1fr 2fr;
    }
</style>