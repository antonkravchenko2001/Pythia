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
            {{marketData.description}}
        </div>
        <div class="field-with-buttons">
            <div class="button-container">
                <button  ref='marketStats' name='marketStats'  @click="click('marketStats')" class="market-info-button" :class="{market: buttons.marketStats}" >Market Stats</button>
                <button v-if='$store.state.user' ref='myPortfolio' name='myPortfolio' @click="click('myPortfolio')" class="portfolio-info-button" :class="{portfolio: buttons.myPortfolio}">My Portfolio</button>
            </div>
            <div v-if='buttons.marketStats' class="item-val market-stats market-stats-dashboard">
                <div>
                </div>
                <div class="market-info-text">No</div>
                <div class="market-info-text">Yes</div>
                <div class="market-info-text">Money Waged</div>
                <div class="market-stats-component no-annot">
                    {{marketData.moneyWaged[0]}}$
                </div>
                <div class="market-stats-component yes-annot">
                    {{marketData.moneyWaged[1]}}$
                </div>
                <div class="market-info-text">Shares Owned</div>
                <div class="market-stats-component no-annot">
                    {{marketData.sharesOwned[0]}}
                </div>
                <div class="market-stats-component yes-annot">
                    {{marketData.sharesOwned[1]}}
                </div>
            </div>
            <div v-if='buttons.myPortfolio' class="item-val market-stats my-portfolio-dashboard">
                <div>
                </div>
                <div class="market-info-text">No</div>
                <div class="market-info-text">Yes</div>
                <div class="market-info-text">Money Waged</div>
                <div class="market-stats-component no-annot">
                    {{playerData.moneyWaged[0]}}$
                </div>
                <div class="market-stats-component yes-annot">
                    {{playerData.moneyWaged[1]}}$
                </div>
                <div class="market-info-text">Shares Owned</div>
                <div class="market-stats-component no-annot">
                    {{playerData.sharesOwned[0]}}
                </div>
                <div class="market-stats-component yes-annot">
                    {{playerData.sharesOwned[1]}}
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import {_getMarketInfo, _getPlayerInfo} from '../../contract-functions/ContractFunctions.js'
    import Moralis from '../../main.js'

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
                playerData: {
                    sharesOwned: [0, 0],
                    moneyWaged: [0, 0]
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

            //get Market data from blockchain
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

            let marketDescription = await Moralis.Cloud.run(
                'getMarkets',
                {filters: {marketId: _marketId}}
            );
            this.marketData.description = marketDescription[0].get('description');

            //update database with blockchain data
            let options = {
                filters: {marketId: _marketId},
                values: {
                    volume: marketInfo.moneyWaged.reduce(
                        (acc, curr) => {return acc + curr;}
                    ),
                    volumeShares: marketInfo.sharesOwned.reduce(
                        (acc, curr) => {return acc + curr;}
                    ),
                    resolved: marketInfo.resolved,
                    winningOutcome: marketInfo.winningOutcome,
                    resolvePrice: marketInfo.resolvePrice
                }
            };
            await Moralis.Cloud.run(
                'setMarket',
                options
            );
            //get playerInfo
            const _player = this
                            .$store
                            .state
                            .user
                            .get('ethAddress');
            const playerInfo = await _getPlayerInfo(_player, _marketId);
            this.playerData.moneyWaged = playerInfo.moneyWaged;
            this.playerData.sharesOwned = playerInfo.sharesOwned;
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
        background-color: #0e2438;
        color: #cecece;
        font-size: 11px;
        font-weight: 300;
        border-radius: 5px;
    }

    .colored-border {
        border: 1.5px solid;
        border-color: #cecece
    }

    .field-with-buttons {
        display: grid;
        grid-template-columns: 1fr;
        grid-template-rows: 1fr 5fr;

    }

    .button-container {
        display: flex;
        justify-content: flex-end;
    }

    .market-info-button {
        background-color: #0b1723;
        margin-bottom: 5px;
        border: none;
        color: #cecece;
        font-size: 13px;
    }

    .market {
        color: #79e2f2;
        margin-bottom: 0px;
    }

    .portfolio-info-button {
        background-color: #0b1723;
        margin-bottom: 5px;
        border: none;
        color: #cecece;
        font-size: 13px;

    }

    .portfolio {
        color: #79e2f2;
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
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: #243b53;
        border: 1.2px solid;
        border-color: #79e2f2;
        font-size: 13px;
    }
    .market-info-text {
        display: flex;
        align-items: center;
        font-size: 12.5px
    }

    .my-portfolio-dashboard {
        border: #79e2f2 1.2px solid;

    }

    .market-stats-dashboard {
        border: #79e2f2 1.2px solid;

    }

    .no-annot {
        border: #ec4d4dc2 1.5px solid;
        color: #ec4d4dc2;
    }

    .yes-annot {
        border: #4decc9c2 1.5px solid;
        color: #4decc9c2;
    }
</style>