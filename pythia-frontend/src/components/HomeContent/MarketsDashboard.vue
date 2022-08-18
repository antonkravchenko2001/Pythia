<template>
    <div class="dashboard-container">
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
                text='Wallet not connected: connect wallet wage money on the market'
                :style="{'margin-bottom':'12px'}"
            />
            <div class="top-dashboard-group">
                <div class="filters-container">
                    <div class="search-bar-container">
                        <input class="search-bar"
                            placeholder="type keywords to find markets"
                            type='text'
                            v-model='searchInput'
                            @keyup="findMarkets"
                        />
                        <i class="fa-solid fa-magnifying-glass search-icon"></i>
                    </div>
                    <span class='checkbox'>
                        markets created by me
                        <input type="checkbox" v-model='checkBox' @change='findMarkets'/>
                    </span>
                </div>
                <CreateMarketButton/>
            </div>  
        </div>     
        <div class="markets-display">
            <div class="market-info unselectable" v-for="market in markets" :key="market">
                <div style="display:flex;justify-content:space-between">
                    <h3 class="asset-pair">{{market['asset'].toUpperCase()}}</h3>
                    <div v-if="market['resolved']" class="resolved">Resolved</div>
                    <div v-if="!market['resolved']" class='unresolved'>Unresolved</div>
                </div>
                <div style="font-size:12; color:#a3b7ce">
                    Will exceed 
                    <span style="font-size:15;color:white">{{market['strikePrice']}}</span>
                     by 
                    <span style="font-size:15;color:white">{{dateToString(market['resolutionDate'])}}</span>
                </div>
                <div style="display:flex;justify-content:space-between">
                    <button  v-if="!market['resolved']"  class='predict-button' @click="$router.push(`/markets/${market['marketId']}`)">Make prediction</button>
                    <button  v-if="market['resolved']"  class='predict-button' @click="$router.push(`/markets/${market['marketId']}`)">Collect reward</button>
                    <span style="display:flex; align-items: center;font-weight:400">TVL: {{Math.round(market['tvl'] * 100) / 100}} Dai</span>
                </div>

            </div>
        </div>
    </div>
</template>

<script>
    import Moralis from '../../main.js'
    import CreateMarketButton from './CreateMarketButton.vue'
    import { dateToStr } from '@/utils.js'
    import AlertWindow from '../subcomponents/AlertWindow.vue'
    import {incorrectChainMessage} from '../../config.js'
    export default { 
        components: {
        CreateMarketButton,
        AlertWindow
    },
        props: ['assetNames'],
        data(){
            return {
                searchInput: '',
                checkBox: false,
                markets: {},
                incorrectChainMessage
            }
        },
        methods: {
            async findMarkets(){
                let creator = null;
                const description = this.searchInput;
                if(this.checkBox){
                    creator = this.$store.state.user.get('ethAddress');
                }
                this.markets = await Moralis.Cloud.run(
                    'getMarkets', 
                    {
                        creator,
                        description
                    }
                )
            },
            getOptions(obj){
                return Object.keys(obj);
            },
            getWageDeadline(market){
                return dateToStr(market['wageDeadline']);
            },
            dateToString(date){
                return dateToStr(date);
            }
        },
        async created(){
            const markets = await Moralis.Cloud.run('getMarkets');
            this.markets = markets;
        }

    }
</script>

<style scoped>

    .dashboard-container {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        background: #07141f;
        border-radius: 15px;
        padding: 30px;
        gap: 30px;
    }

    .top-dashboard-group {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .title{
        font-family: 'Montserrat';
        font-size: 24px;
        color: #ffffff;
        margin-bottom: 15px;
        border-radius: 5px;
    }

    .filters-container {
        display:flex;
        gap:20px;
        align-items:center;
        height:100%;
    }

    .search-bar-container {
        height:100%;
        position:relative;
        width: 260px;
    }

    .search-bar{
        border: 1.2px solid #a3b7ce;
        background: #0f1f2f;
        color: #ffffff;
        border-radius: 25px;
        padding-left: 35px;
        padding-right: 15px;
        width: min(200px, 100%);
        height: min(100%, 25px);
    }

    .search-icon {
        color:#a3b7ce;
        font-size: 14px;
        position: absolute;
        left: 15px;
        top: 35%;
    }

    .checkbox {
        display:flex;
        align-items:center;
        gap: 5px;
        color:#ffffff;
        font-size: 13px;
        font-weight:350;
        font-family:'Montserrat'
    }

    .markets-display {
        display: grid;
        gap: 10px;
        padding-bottom: 10px;
        grid-template-columns: repeat(3, minmax(250px, 1fr));
        grid-auto-rows: minmax(170px, 1fr);
    }

    .market-info{
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        padding:15px;
        border-radius: 10px;
        background-color: #102438;
        color:#ffffff;
        font-size: 13px;
        font-family: 'Montserrat';
        font-weight: 350;
        cursor: pointer;
    }

    .asset-pair {
        margin: 0px;
        font-weight: 450;
        font-size: 18px;
    }

    .predict-button {
        border-radius: 10px;
        border: none;
        padding: 5px;
        width: max(50%, 130px);
    }

    .predict-button:hover {
        background: #a3b7ce;
    }

    .item-container{
        display: flex;
        justify-content: space-between;
    }

    .unselectable {
        -moz-user-select: none;
        -khtml-user-select: none;
        -webkit-user-select: none;
        -ms-user-select: none;
        user-select: none;
    }

    .description{
        font-size: 14px;
        font-weight: 500;
    }

    .unresolved {
        color: #ffffff;
        background: #c92204bc;
        border-radius: 15px;
        padding: 3px;
        display: flex;
        justify-content: center;
        width: 90px;
    }

    .resolved {
        color: #ffffff;
        background: #02d70894;
        border-radius: 15px;
        padding: 3px;
        display: flex;
        justify-content: center;
        width: 90px;
    }

    @media (max-width: 899px) {
        .markets-display {
            grid-template-columns: repeat(2, minmax(250px, 1fr));
        }
    }

    @media (max-width: 500px) {
        .markets-display {
            grid-template-columns: repeat(1, minmax(250px, 1fr));
        }
    }

</style>