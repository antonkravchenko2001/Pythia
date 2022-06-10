<template>
    <div class="market-info">
        <div class="info-container">
            <div class="info-container">
                <div class="item-name">Asset</div>
                <div class="item-val">{{marketData.asset}}</div>
            </div>
            <div class="info-container">
                <div class="item-name">Strike Price</div>
                <div class="item-val">{{marketData.strikePrice}}</div>
            </div>
        </div>
        <div class="info-container">
            <div class="info-container">
                <div class="item-name">Wage Deadline</div>
                <div class="item-val">{{marketData.wageDeadline}}</div>
            </div>
            <div class="info-container">
                <div class="item-name">Resolve Date</div>
                <div class="item-val">{{marketData.resolveDate}}</div>
            </div>
        </div>
        <div class='item-val'>
            eTH VS USD Market
        </div>
        <div class="field-with-buttons">
            <div class="button-container">
                <button  ref='marketStats' name='marketStats'  @click="click('marketStats')" class="market-info-button" :class="{market: buttons.marketStats}" >Market Stats</button>
                <button ref='myPortfolio' name='myPortfolio' @click="click('myPortfolio')" class="portfolio-info-button" :class="{portfolio: buttons.myPortfolio}">My Portfolio</button>
            </div>
            <div v-if='buttons.marketStats' class="item-val market-stats market-stats-dashboard">
                <div>
                </div>
                <div class="market-info-text">No</div>
                <div class="market-info-text">Yes</div>
                <div class="market-info-text">Money Waged</div>
                <div class="market-stats-component">
                    {{marketData.moneyWaged[0]}}
                </div>
                <div class="market-stats-component">
                    {{marketData.moneyWaged[1]}}
                </div>
                <div class="market-info-text">Shares Owned</div>
                <div class="market-stats-component">
                    {{marketData.sharesOwned[0]}}
                </div>
                <div class="market-stats-component">
                    {{marketData.sharesOwned[1]}}
                </div>
            </div>
            <div v-if='buttons.myPortfolio' class="item-val market-stats my-portfolio-dashboard">
                <div>
                </div>
                <div class="market-info-text">No</div>
                <div class="market-info-text">Yes</div>
                <div class="market-info-text">Money Waged</div>
                <div class="market-stats-component">
                </div>
                <div class="market-stats-component">
                </div>
                <div class="market-info-text">Shares Owned</div>
                <div class="market-stats-component">
                </div>
                <div class="market-stats-component">
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import {_getMarketInfo} from '../../contract-functions/ContractFunctions.js'

    export default {
        data(){
            return {
                marketData : {
                    asset: '',
                    strikePrice: 0,
                    wageDeadline: '',
                    resolveDate: '',
                    description: '',
                    sharesOwned: [0, 0],
                    moneyWaged: [0, 0],
                },
                buttons: {
                    marketStats: true,
                    myPortfolio: false
                }
            }

        },
        methods: {
            click(btn) {
                const buttonName = this.$refs[btn].name;
                if(!this.buttons[buttonName]){
                    this.buttons[buttonName] = true;
                    if(buttonName === 'myPortfolio'){
                        this.buttons.marketStats = false;
                    } else if(buttonName === 'marketStats') {
                        this.buttons.myPortfolio = false;
                    }
                }
            }
        },
        async created(){
            const _marketId = this
                            .$route
                            .params
                            .marketId
                            .toString();
            const marketInfo = await _getMarketInfo(_marketId);
            this.marketData.asset = marketInfo.asset;
            this.marketData.strikePrice = Math.round(marketInfo.strikePrice);
            this.marketData.resolveDate = marketInfo.resolveDate;
            this.marketData.wageDeadline = marketInfo.wageDeadline;
            this.marketData.sharesOwned = marketInfo.sharesOwned;
            this.marketData.moneyWaged = marketInfo.moneyWaged;
        }
    };
</script>


<style scoped>

    .market-info {
        display: grid;
        gap: 20px;
        grid-template-columns: 1fr;
        grid-template-rows: 1fr 1fr 2fr 6fr;

    }
    .info-container {
        display: flex;
        grid-column-start: 1;
        justify-content: space-between;
    }

    .item-name {
        padding: 5px;
        border: none;
        color: #cecece;
        font-size: 12px;
    }
    .item-val {
        border: none;
        padding: 5px;
        background-color: #122D46;
        color: #cecece;
        font-size: 11px;
        font-weight: 300;
    }

    .colored-border {
        border: 1.5px solid;
        border-color: #cecece
    }

    .field-with-buttons {
        display: grid;
        grid-template-columns: 1fr;
        grid-template-rows: 1fr 6fr;

    }

    .button-container {
        display: flex;
        justify-content: flex-end;
    }

    .market-info-button {
        background-color: #0b1723;
        margin-bottom: 1.5px;
        border: none;
        color: #cecece;
        font-size: 13px;
    }

    .market {
        color: #57D9A3;
        margin-bottom: 0px;
        background-color: #122D46;
    }

    .portfolio-info-button {
        background-color: #0b1723;
        margin-bottom: 1.5px;
        border: none;
        color: #cecece;
        font-size: 13px;

    }

    .portfolio {
        color: #79e2f2;
        background-color: #122D46;
        margin-bottom: 0px;
    }

    .market-stats {
       display: grid;
       row-gap: 10px;
       column-gap: 10px;
       grid-template-columns: 2fr 2fr 2fr;
       grid-template-rows: 0.3fr 1fr 1fr;
       padding-left: 20px;
       padding-right: 20px;
       padding-bottom: 10px;
       padding-top: 10px;
    }

    .market-stats-component {
        background-color: #243b53;
        border: 1.2px solid;
        border-color: #79e2f2;
        font-size: 13px;
    }
    .market-info-text {
        font-size: 12.5px
    }

    .my-portfolio-dashboard {
        border: #79e2f2 1.5px solid;

    }

    .market-stats-dashboard {
        border: #57D9A3 1.5px solid;

    }
</style>