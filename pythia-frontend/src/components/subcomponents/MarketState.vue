<template>
    <div class="market-state-container">
        <div v-if='isResolved' class="market-resolved">Resolved</div>
        <div v-if='!isResolved' class="market-unresolved">Unresolved</div>
    </div>

</template>


<script>
import { _getMarketInfo } from '../../contract-functions/ContractFunctions.js';

    export default {
        data(){
            return {
                isResolved: false
            }
        },
        async created(){
            const _marketId = this
                        .$route
                        .params
                        .marketId
                        .toString();
            const marketInfo = await _getMarketInfo(_marketId);
            this.isResolved = marketInfo.resolved;
        }
    };
</script>

<style scoped>
    .market-state-container {
        display: flex;
        justify-content: flex-end;
    }

    .market-resolved {
        background-color:#17783b;
        border: none;
        border-radius: 5px;
        padding: 5px;
        font-size: 12px;
        color:#cecece;
    }
    .market-unresolved {
        background-color:#7e2525;
        border: none;
        border-radius: 5px;
        padding: 5px;
        font-size: 12px;
        color:#cecece;
    }
</style>