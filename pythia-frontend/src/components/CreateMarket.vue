<template>
    <input type="number" required v-model='sharesOwned[0]'/>
    <input type="number" required v-model='sharesOwned[1]'/>
    <input type="number" required v-model='moneyWaged[0]'/>
    <input type="number" required v-model='moneyWaged[1]'/>
    <input type="text" required v-model='priceFeedAddress'/>
    <input type="number" required v-model='strikePrice' />
    <input type="number" required v-model='resolutionDate' />
    <input type="number" required v-model='wageDeadline'/>
    <button @click="createMarket">Create Market</button>
    <button @click="approve">approve</button>
</template>

<script>
import { _createMarket, _getMarketInfo} from '../ContractFunctions.js';

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
</style>