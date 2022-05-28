<template>
    <div>
        <router-link to="/"></router-link>
    </div>
</template>

<script>
import { _wageMoney, _getMarketInfo} from '../contract-functions/ContractFunctions.js';

export default {
    data() {
        return  {
            moneyWaged: [0, 0],
            marketId: '0'
        };
    },
    methods: {
        async wageMoney() {
            const params = {
                _moneyWaged: this.moneyWaged,
                _marketId: this.marketId,
            };
            await _wageMoney(params);
            await _getMarketInfo(this.marketId);
        },
    }
}
</script>

<style scoped>
</style>