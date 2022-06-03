<template>
    <div class="container">
        <div class="market-info-space">
            <div class="market-info">
                <div class="info-container">
                    <div class="info-container">
                        <div class="item-name">Asset</div>
                        <div class="item-val">ETH / USD</div>
                    </div>
                    <div class="info-container">
                        <div class="item-name">Strike Price</div>
                        <div class="item-val">2000</div>
                    </div>
                </div>
                <div class="info-container">
                    <div class="info-container">
                        <div class="item-name">Wage Deadline</div>
                        <div class="item-val">01/02/2022</div>
                    </div>
                    <div class="info-container">
                        <div class="item-name">Resolution Date</div>
                        <div class="item-val">03/02/2022</div>
                    </div>
                </div>
                <div class='item-val'>
                    eTH VS USD Market
                </div>
                <div class="field-with-buttons">
                    <div class="button-container">
                        <button class="market-info-button">Market Stats</button>
                        <button class="portfolio-info-button">My Portfolio</button>
                    </div>
                    <div class="item-val market-stats">
                        <div class="market-stats-component">
                        </div>
                        <div class="market-stats-component">
                        </div>
                        <div class="market-stats-component">
                        </div>
                        <div class="market-stats-component">
                        </div>
                    </div>
                </div>
            </div>
            <div>
                <div>
                </div>
                <div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import {_wageMoney, deposited} from '../contract-functions/ContractFunctions.js';

export default {
    data() {
        return  {
            moneyWaged: [0, 0],
        };
    },
    methods: {
        getMarketId(){
            return this.$route.params.marketId.toString();
        },
        async wageMoney() {
            const params = {
                _moneyToWage: this.moneyWaged,
                _marketId: this.getMarketId()
            };
            await _wageMoney(params);
            await deposited();
        },
    },

}
</script>

<style scoped>
    .container {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        font-family: sans-serif;
    }
    .market-info-space {
        display: grid;
        gap: 15px;
        grid-template-columns: 5fr 3fr;
        background-color: #0E1D2C;
        padding: 15px;
        box-shadow: 1px 1px 8px #121212;
    }

    .market-info {
        display: grid;
        gap: 15px;
        grid-template-columns: 1fr;
        grid-template-rows: 1fr 1fr 2fr 4.5fr;
        border: 1.5px solid;
        padding: 10px;
        border-color: #508cff7d;

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
        font-size: 13px;
    }
    .item-val {
        border: none;
        border-radius: 5px;
        padding: 5px;
        background-color: #243b53;
        border-radius: 5px;
        color: #cecece;
        font-size: 13px;
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
        background-color: #0E1D2C;
        border: none;
        color: #cecece;

    }

    .market-info-button:hover {
        color: #57D9A3;
        border-bottom: 1.5px solid;
        border-color: #57D9A3;
    }

    .portfolio-info-button {
        background-color: #0E1D2C;
        border: none;
        color: #cecece;

    }

    .portfolio-info-button:hover {
        color: #79e2f2;
        border-bottom: 1.5px solid;
        border-color: #79e2f2;
    }

    .market-stats {
        display: grid;
        gap: 10px;
        grid-template-columns: repeat(2, 1fr);
        grid-template-rows: repeat(2, 1fr);

    }

    .market-stats-component {
        background-color: #0E1D2C;
        border: 1.2px solid;
        border-color: #79e2f2;
    }
</style>