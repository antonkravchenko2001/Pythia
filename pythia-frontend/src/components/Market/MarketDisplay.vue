<template>
    <div v-if='marketExists' class="container-around">
        <div v-if='marketData.marketInfo' class="market-info-space">
            <MarketStats :marketData='marketData'/>
            <div class="state-and-buy-container">
                <MarketState :marketData='marketData'/>
                <MarketActions :marketData='marketData'/>
            </div>
        </div>
    </div>
    <div v-if="!$store.state.chainCorrect" class="alert">
        <Alert background='#ff000080' color='white' message='Error:' text='Incorrect network, please switch to Polygon'/>
    </div>
    <div v-if="!marketExists">
        <PageNotFound/>
    </div>
</template>

<script>
import MarketStats from './MarketStats.vue'
import { defineAsyncComponent } from 'vue'
import MarketActions from './MarketActions.vue'
import MarketState from './MarketState.vue'
import {_getMarketInfo, _getPlayerInfo, _getReward, _getExpertScore} from '../../contract-functions/ContractFunctions.js'
import Moralis from '../../main.js'
export default {
    components: {
        MarketStats,
        MarketState,
        MarketActions,
        Alert: defineAsyncComponent(() =>
            import('../subcomponents/AlertWindow.vue')
        ),
        PageNotFound: defineAsyncComponent(() => 
            import('../subcomponents/PageNotFound.vue')
        )
    },
    data(){
        return {
            marketExists: true,
            marketData: {
                marketInfo: null,
                playerInfo: {
                    marketId: null
                },
                withDrawStats: {}
            }
        }
    },
    methods: {
        //load market info
        async loadMarket(marketId){
            let marketInfo = await _getMarketInfo(marketId);
            marketInfo['marketId'] = marketId;
            return marketInfo;
        },

        //load player info
        async loadPlayer(player, marketId){
            let playerInfo = await _getPlayerInfo(player, marketId);
            playerInfo['player'] = player;
            playerInfo['marketId'] = marketId;
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
        },
        async updateMarketState(){
            Moralis.Cloud.run(
                'saveMarket',
                {
                    marketId: this.marketData.marketInfo.marketId,
                    values: {
                        resolved: this.marketData.marketInfo.resolved,
                        resolutionPrice: this.marketData.marketInfo.resolutionPrice,
                        winningOutcome: this.marketData.marketInfo.winningOutcome
                    }
                }
            )
            console.log('market updated');
        },
        async loadInfo(){
            const marketId = this
                        .$route
                        .params
                        .marketId
                        .toString();
            this.marketExists = await Moralis.Cloud.run(
                'checkMarketExistence',
                {marketId}
            )
            if(this.marketExists){
                this.marketData.marketInfo = await this.loadMarket(
                    marketId
                );
                await this.updateMarketState();
                if(this.$store.state.user){
                    const player = this.$store.state.user.get('ethAddress');
                    this.marketData.playerInfo = await this.loadPlayer(player, marketId)
                    if(this.marketData.marketInfo.resolved){
                        this.marketData.withDrawStats =  await this.loadWithdrawStats(player, marketId);
                    }
                }

            }
        }
    },
    watch: {
        '$store.state.user': async function(newVal){
            if(newVal && (this.marketData.playerInfo !== null)){
                const marketId = this
                        .$route
                        .params
                        .marketId
                        .toString()
                const player = this.$store.state.user.get('ethAddress');
                this.marketData.playerInfo = await this.loadPlayer(player, marketId)
                if(this.marketData.marketInfo.resolved){
                    this.marketData.withDrawStats =  await this.loadWithdrawStats(player, marketId);
                }
            }
        }
    },
    async created() {
        this.loadInfo();
    }
}
</script>

<style scoped>
    .container-around {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        position: relative;
        top: 10%;
        font-family: 'Montserrat';
        font-weight: 400;
    }
    .market-info-space {
        font-size: 13px;
        display: grid;
        gap: 50px;
        grid-template-columns: 5fr 3fr;
        background-color: #0a1e30;
        border-radius: 15px;
        padding: 20px;
    }

    .state-and-buy-container {
        display: grid;
        grid-template-rows: 1fr 2fr;
    }

    .alert{
        position: absolute;
        width:max-content;
        right:5px;
        z-index:100;
        top: 33px;
    }
</style>