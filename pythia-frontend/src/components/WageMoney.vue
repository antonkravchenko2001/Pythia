<template>
    <div>
        <input type="number" required v-model='moneyWaged[0]'/>
        <input type="number" required v-model='moneyWaged[1]'/>
        <button @click="wageMoney">Wage Money</button>
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
</style>