<template>
    <div>
        <h3 class="title">
            Available Markets
        </h3>
        <div class="filters-container">
            <div style="display:flex; align-items: center;">
                <div style='margin-left:10px;font-size: 14px'>TVL:</div>
                <DropDown 
                    defaultValue="All"
                    :objects="getOptions(volumeOptions)"
                    height="80px"
                    background="#235284"
                    ref="volumeOptions"
                    style='width: 70px; margin: 5px'
                />
                <div style='margin-left:10px;font-size: 14px'>Asset:</div>
                <DropDown 
                    defaultValue="All"
                    :objects="assetNames"
                    height="100px"
                    background="#235284"
                    ref="assetNames"
                    style='width: 100px; margin: 5px'
                />
                <div style="margin-left:10px;font-size: 14px">Wage Deadline:</div>
                <DropDown 
                    defaultValue="All"
                    :objects="getOptions(wageDeadlineOptions)"
                    height="100px"
                    background="#235284"
                    ref="wageDeadlineOptions"
                    style='width: 100px; margin: 5px'
                />
            </div>
            <button class='apply-button' @click="findMarkets()">Apply filters</button>
        </div>
        <div class="markets-display">
            <div class="market-info unselectable" v-for="market in markets" :key="market" @click="$router.push(`/markets/${market['marketId']}`)">
                <div class="description">{{getDescription(market)}}</div>
                <div style="font-size:12; color:#cecece">
                    Wage Deadline:
                    {{getWageDeadline(market)}}
                </div>
                <div class="item-container">
                    <span style="display:flex; align-items: center;font-weight:400">TVL: {{Math.round(market['tvl'] * 100) / 100}} Dai</span>
                    <div v-if="market['resolved']" class="resolved">Resolved</div>
                    <div v-if="!market['resolved']" class='unresolved'>Unresolved</div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Moralis from '../../main.js'
    import DropDown from '../subcomponents/DropDown.vue'
    import { dateToStr } from '@/utils.js'
    export default {
        components: {
            DropDown
        },
        props: ['assetNames', 'volumeOptions', 'wageDeadlineOptions'],
        data(){
            return {
                searchInput: '',
                markets: {}
            }
        },
        methods: {
            async findMarkets(){
                let asset = this.$refs.assetNames.input;
                const tvl = this.volumeOptions[this.$refs.volumeOptions.input];
                const wageDeadline = this.wageDeadlineOptions[this.$refs.wageDeadlineOptions.input];
                this.markets = await Moralis.Cloud.run(
                    'getMarkets', 
                    {
                        asset,
                        tvl,
                        wageDeadline
                    }
                )
                console.log(this.markets);
            },
            getOptions(obj){
                return Object.keys(obj);
            },
            getWageDeadline(market){
                return dateToStr(market['wageDeadline']);
            },
            getDescription(market){
                return (
                    'Will' + ' ' +
                    market['asset'].toUpperCase() + ' ' +
                    'exceed' + ' ' +
                    market['strikePrice'] + ' ' +
                    'by' + ' ' + 
                    dateToStr(market['resolutionDate']) + ' ' + 
                    '?'
                );
            }
        },
        async created(){
            const markets = await Moralis.Cloud.run('getMarkets');
            this.markets = markets;
            console.log('market', markets);
        }

    }
</script>

<style scoped>

    .filters-container {
        display:flex;
        margin-bottom: 25px;
        justify-content: space-between;
        align-items: center;
        color: #ffffff;
        font-family: 'Montserrat';
        background: linear-gradient(90deg, #15344f 0%, rgba(18,47,74,1) 75%, rgb(23, 60, 94) 100%);
        box-shadow: 1px 1px 5px #121212;
        border-radius: 5px;
        padding: 10px;
        font-size: 13px;
        gap: 5px;
    }

    .apply-button {
        background: #00804d;
        padding: 7px;
        border-radius: 3px;
        box-shadow: 1px 1px 8px rgba(18,47,74,1);
        border: none;
        color: #ffffff;
    }

    .apply-button:hover{
        background: #00603a;
        box-shadow: none;
    }

    .title{
        font-family: 'Montserrat';
        font-size: 24px;
        color: #ffffff;
        margin-bottom: 15px;
        border-radius: 5px;
    }

    .markets-display {
        display: grid;
        gap: 20px;
        padding-bottom: 10px;
        grid-template-columns: repeat(auto-fit, 300px);
        grid-template-rows: repeat(auto-fit, minmax(140px, 1fr));
    }

    .market-info{
        display: grid;
        grid-template-rows: 1fr 3fr 1fr;
        gap: 10px;
        padding:10px;
        border-radius: 10px;
        background-color: #102438;
        box-shadow: 1px 1px 8px #121212;
        color:#ffffff;
        font-size: 13px;
        font-family: 'Montserrat';
        font-weight: 350;
        cursor: pointer;
        max-height: 140px;
    }

    .market-info:hover{
        background-color: #183452;
        box-shadow: none;
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
        padding: 5px;
        display: flex;
        justify-content: center;
        width: 80px;
    }

    .resolved {
        color: #ffffff;
        background: #02d70894;
        border-radius: 15px;
        padding: 5px;
        display: flex;
        justify-content: center;
        width: 80px;
    }
</style>