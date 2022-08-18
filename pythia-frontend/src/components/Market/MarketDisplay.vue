<template>
    <div v-if='marketExists' class="container-around">
        <div v-if='marketData.marketInfo' class="market-info-container">
            <div style="display:flex;flex-direction: column;">
                <AlertWindow 
                    v-if="!$store.state.chainCorrect"
                    style='font-family:monospace'
                    color='red'
                    :text='incorrectChainMessage'
                    :style="{'margin-bottom':'12px'}"
                />
                <AlertWindow 
                    v-if="!$store.state.user"
                    style='font-family:monospace'
                    color='yellow'
                    text='Wallet not connected: connect wallet to make predictions'
                    :style="{'margin-bottom':'12px'}"
                />
            </div>
            <div class="market-info-space">
                <MarketStats :marketData='marketData'/>
                <div class="state-and-buy-container">
                    <MarketState :marketData='marketData'/>
                    <MarketActions :marketData='marketData' ref='marketActions'/>
                </div>
            </div>
        </div>
    </div>
    <div v-if="!$store.state.chainCorrect" class="alert">
        <Alert background='#ff000080' color='white' message='Error:' text='Incorrect network, please switch to Kovan'/>
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
import {incorrectChainMessage} from '../../config.js'
import Moralis from '../../main.js'

export default {
        components: {
        MarketStats,
        MarketState,
        MarketActions,
        AlertWindow: defineAsyncComponent(() => import("../subcomponents/AlertWindow.vue")),
        PageNotFound: defineAsyncComponent(() => import("../subcomponents/PageNotFound.vue")),
    },
    data(){
        return {
            marketExists: true,
            marketData: {
                marketInfo: null,
                playerInfo: {
                    marketId: null
                },
                withDrawStats: {},
            },
            incorrectChainMessage
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
        async loadInfo(){
            //get market id
            const marketId = this
                        .$route
                        .params
                        .marketId
                        .toString();

            //check whether market exists
            this.marketExists = await Moralis.Cloud.run(
                'checkMarketExistence',
                {marketId}
            )

            //if market exists  load market info
            if(this.marketExists){
                this.marketData.marketInfo = await this.loadMarket(
                    marketId
                );

                // if user connected wallet
                if(this.$store.state.user){

                    //load player
                    const player = this.$store.state.user.get('ethAddress');
                    this.marketData.playerInfo = await this.loadPlayer(player, marketId)

                    //if market is resolved get withdraw stats
                    if(this.marketData.marketInfo.resolved){
                        this.marketData.withDrawStats =  await this.loadWithdrawStats(player, marketId);
                    }
                }

            }
        }
    },
    watch: {
        '$store.state.user': function(newVal){
            if(newVal && (this.marketData.playerInfo !== null)){
                const marketId = this
                        .$route
                        .params
                        .marketId
                        .toString()
                const player = this.$store.state.user.get('ethAddress');
                this.loadPlayer(player, marketId)
                    .then(
                        (playerInfo) => {
                            this.marketData.playerInfo = playerInfo;
                        }
                    )
                if(this.marketData.marketInfo.resolved){
                    this.loadWithdrawStats(player, marketId)
                        .then(
                            (withDrawStats) => {
                                this.marketData.withDrawStats =  withDrawStats;
                            }
                        );
                }
            }
        }
    },
    async mounted(){
        await this.loadInfo();
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
        font-family: 'Montserrat';
        font-weight: 400;
    }
    .market-info-container {
        font-size: 14px;
        background-color: #07141f;
        border-radius: 15px;
        padding: 25px;
    }

    .market-info-space{
        display: grid;
        gap: 50px;
        grid-template-columns: 5fr 3fr;
    }

    .state-and-buy-container {
        display: grid;
        grid-template-rows: 1fr 2fr;
    }
</style>