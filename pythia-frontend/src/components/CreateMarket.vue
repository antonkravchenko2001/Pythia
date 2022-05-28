<template>
    <div class="flex-container">
        <div class="grid">
        <input type="text" class='long-input'>
        <input type="text" class='long-input' required v-model='priceFeedAddress'/>
        <input type="number" class='long-input' required v-model='strikePrice' />
        <input type="number" required v-model='resolutionDate' />
        <input type="number" required v-model='wageDeadline'/>
        <input type="number" required v-model='sharesOwned[0]'/>
        <input type="number" required v-model='sharesOwned[1]'/>
        <input type="number" required v-model='moneyWaged[0]'/>
        <input type="number" required v-model='moneyWaged[1]'/>
        <textarea class='long-input text-area'></textarea>
        <button @click="createMarket" class="submit-button">Create Market</button>
    </div>
    </div>
</template>

<script>
import { _createMarket, _getMarketInfo} from '../contract-functions/ContractFunctions.js';

export default {
    data() {
        return  {
            sharesOwned: [0, 0],
            moneyWaged: [0, 0],
            priceFeedAddress: '0',
            strikePrice: 0,
            resolutionDate: 0,
            wageDeadline: 0
        };
    },
    methods: {
        async createMarket() {
            const params = {
                _sharesOwned: this.sharesOwned,
                _moneyWaged: this.moneyWaged,
                _priceFeedAddress: this.priceFeedAddress,
                _strikePrice: this.strikePrice,
                _resolutionDate: this.resolutionDate,
                _wageDeadline: this.wageDeadline,
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
        column-gap: 5px;
        grid-template-columns: repeat(2, minmax(120px, 150px));
        grid-template-rows: repeat(9, 1fr);
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
</style>