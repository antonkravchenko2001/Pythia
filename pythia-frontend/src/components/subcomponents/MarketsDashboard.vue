<template>
    <div >
        <div class="title">
            Available Markets
        </div>
        <div class="filters-container">
            <div style="margin-right: 10px; font-size: 14px">Filter by</div>
            <div style="display:flex; justify-content:center; align-items:center">
                <div style='margin-left:10px;font-size: 14px'>Volume:</div>
                <DropDown 
                    :objects="getOptions(volumeOptions)"
                    height="80px"
                    background="#091420"
                    ref="volumeOptions"
                    style='width: 60px; margin: 5px'
                />
                <div style='margin-left:10px;font-size: 14px'>Asset:</div>
                <DropDown 
                    :objects="assetNames"
                    height="80px"
                    background="#091420"
                    ref="assetNames"
                    style='width: 100px; margin: 5px'
                />
                <div style="margin-left:10px;font-size: 14px">Wage Deadline:</div>
                <DropDown 
                    :objects="getOptions(wageDeadlineOptions)"
                    height="80px"
                    background="#091420"
                    ref="wageDeadlineOptions"
                    style='width: 100px; margin: 5px'
                />
            </div>
            <button class='apply-button' @click="findMarkets()">Apply filters</button>
        </div>
        <div class="markets-display">
            <div class="market-info unselectable" v-for="market in markets" :key="market" @click="$router.push(`/markets/${market.get('marketId')}`)">
                <div>
                    <div class="item-val description">{{getDescription(market)}}</div>
                </div>
                <div>
                    Wage Deadline:
                    {{getWageDeadline(market)}}
                </div>
                <div class="item-container">
                    <div style="display: flex">
                        <div class="item-type">Volume: </div>
                        <div class="item-val">{{Math.round(market.get('volume') * 100) / 100}} Dai</div> 
                    </div>
                    <div>
                        <div v-if="market.get('resolved')" style="color:#4decc9c2">Resolved</div>
                        <div v-if="!market.get('resolved')" style="color:#ec4d4dc2">Unresolved</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Moralis from '../../main.js'
    import DropDown from './DropDown.vue'
    import { dateToStr } from '@/helperFunctions.js'
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
                const asset = this.$refs.assetNames.input.toLowerCase();
                const volume = this.volumeOptions[this.$refs.volumeOptions.input];
                const wageDeadline = this.wageDeadlineOptions[this.$refs.wageDeadlineOptions.input];
                console.log(wageDeadline, volume, asset);
                this.markets = await Moralis.Cloud.run(
                    'getMarkets', 
                    {
                        filters: {
                            asset,
                            volume,
                            wageDeadline
                        }
                    }
                )
            },
            getOptions(obj){
                return Object.keys(obj);
            },
            getWageDeadline(market){
                return dateToStr(market.get('wageDeadline'));
            },
            getDescription(market){
                return (
                    'Will' + ' ' +
                    market.get('asset').toUpperCase() + ' ' +
                    'exceed' + ' ' +
                    market.get('strikePrice') + ' ' +
                    'by' + ' ' + 
                    dateToStr(market.get('resolveDate')) + ' ' + 
                    '?'
                );
            }
        },
        async created(){
            const markets = await Moralis.Cloud.run('getMarkets');
            this.markets = markets;
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
        background: linear-gradient(90deg, rgb(35, 91, 138) 0%, rgba(18,47,74,1) 75%, rgb(23, 60, 94) 100%);
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
        font-weight: 500;
        font-size: 20px;
        color: #ffffff;
        margin-bottom: 15px;
        border-radius: 5px;
        width: max-content;
        box-shadow: 1px 1px 5px #121212;
        padding: 10px;
        background: linear-gradient(90deg, rgb(35, 91, 138) 0%, rgba(18,47,74,1) 75%, rgb(23, 60, 94) 100%);
    }

    .markets-display {
        display: grid;
        gap: 15px;
        padding-bottom: 10px;
        grid-template-columns: repeat(auto-fit, 270px);
        grid-template-rows: repeat(auto-fit, 130px);
    }

    .market-info{
        display: grid;
        grid-template-rows: 1fr 3fr 1fr;
        gap: 10px;
        outline: 1.2px solid #935cff;
        background: linear-gradient( 
            90deg,
            rgb(19 60 94) 0%,
            rgb(12 38 61) 45%,
            rgb(12 40 67) 100% 
        );
        padding:10px;
        border-radius: 10px;
        box-shadow: 1px 1px 8px #121212;
        color:#ffffff;
        font-size: 12px;
        font-family: 'Montserrat';
        font-weight: 350;
        cursor: pointer;
    }

    .market-info:hover{
        background-color: #102135;
        box-shadow: none;
    }

    .market-info:hover{
        box-shadow: 1px 1px 8px #121212;
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
        background: #072841;
        padding: 2px;
        border-radius: 5px;
        box-shadow: 1px 1px 4px #121212;
    }

    .item-type{
        font-weight: 200;
        padding-right: 5px;
    }
    
    .item-val{
        font-weight: 300;
        padding-right: 5px;
    }
</style>