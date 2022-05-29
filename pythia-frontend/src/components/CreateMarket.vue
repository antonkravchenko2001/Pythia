<template>
    <button v-if="!clicked" @click="click()" >create market</button>
    <div v-if="clicked" class="flex-container">
        <div class="grid">
            <input type="text" class='long-input'>
            <input type="text" class='long-input' required v-model='marketParams.priceFeedAddress'/>
            <input type="number" class='long-input' required v-model='marketParams.strikePrice' />
            <input type="number" required v-model='marketParams.resolutionDate' />
            <input type="number" required v-model='marketParams.wageDeadline'/>
            <input type="number" required v-model='marketParams.sharesOwned[0]'/>
            <input type="number" required v-model='marketParams.sharesOwned[1]'/>
            <input type="number" required v-model='marketParams.moneyWaged[0]'/>
            <input type="number" required v-model='marketParams.moneyWaged[1]'/>
            <textarea class='long-input text-area'></textarea>
            <button @click="createMarket" class="submit-button">create market</button>
            <button @click="close()" class="close-button">cancel</button>
        </div>
    </div>
</template>

<script>
import { _createMarket, _getMarketInfo} from '../contract-functions/ContractFunctions.js';

export default {
    data() {
        return  {
                marketParams: {
                    sharesOwned: [0, 0],
                    moneyWaged: [0, 0],
                    priceFeedAddress: '0',
                    strikePrice: 0,
                    resolutionDate: 0,
                    wageDeadline: 0
                },
                clicked : false
        };
    },
    methods: {
        click() {
            this.clicked = true;
        },
        close() {
            this.clicked = false;
        },
        async createMarket() {
            const params = {
                _sharesOwned: this.marketParams.sharesOwned,
                _moneyWaged: this.marketParams.moneyWaged,
                _priceFeedAddress: this.marketParams.priceFeedAddress,
                _strikePrice: this.marketParams.strikePrice,
                _resolutionDate: this.marketParams.resolutionDate,
                _wageDeadline: this.marketParams.wageDeadline,
            };
            await _createMarket(params);
            await _getMarketInfo('0');
        },
    }
}
</script>

<style scoped>

    .flex-container {
        display: flex;
        justify-content: center;
    }
    .grid {
        display: grid;
        row-gap: 10px;
        column-gap: 10px;
        grid-template-columns: repeat(2, minmax(120px, 150px));
        grid-template-rows: repeat(9, 1fr);
        background-color: #151515;
        box-shadow: 1px 1px 8px #151515;
        border: none;
        border-radius: 5px;
        padding: 15px;
    }

    .long-input {
        grid-column-start: 1;
        grid-column-end: 3;
    }

    .text-area {
        grid-row-start: 7;
        grid-row-end: 9;
    }

    .submit-button {
        grid-column-start: 2;
        grid-column-end: 3;
        border: none;
        border-radius: 15px;
        background-color: #2968a7;
        color:#e1e1e1;
        box-shadow: 1px 1px 8px #121212;
    }
    .submit-button:hover{
        background-color: #1f5082;
    }

    .close-button {
        grid-column-start: 1;
        grid-column-end: 2;
        grid-row-start: 9;
        border: 1.5px solid;
        border-color: #c62828b1;
        border-radius: 15px;
        background-color: #212121;
        color:#e1e1e1;
        box-shadow: 1px 1px 8px #121212;
    }

    .close-button:hover {
        background-color: #c62828b1;
    }
</style>