<template>
    <div v-if="marketData.marketInfo.resolved" class='outer-container'>
        <div class="market-state-container">
            <div class="market-resolved">Resolved</div>
        </div>
        <div class="winning-outcome-container">
            <div>Winning Outcome:</div>
            <div>{{marketData.marketInfo.winningOutcome}}</div>
        </div>
        <div class="winning-outcome-container">
            <div>Resolution price:</div>
            <div>{{round(marketData.marketInfo.resolvePrice)}}</div>
        </div>
    </div>
    <div v-if="!marketData.marketInfo.resolved" class="market-state-container">
        <div  class="market-unresolved">Unresolved</div>
    </div>

</template>


<script>
    import { roundNum } from '../../utils.js';
    export default {
        props: ['marketData'],
        methods: {
            round(num){
                return roundNum(num);
            }
        }
    };
</script>

<style scoped>
    .outer-container {
        display: grid;
        gap: 8px;
        grid-template-rows: repeat(2, 1fr);
        max-height: 70px;
        border:#17783b 1.2px solid;
        border-radius: 5px;
        padding: 9px;
    }
    .market-state-container {
        display: flex;
        justify-content: flex-end;
    }

    .resolved-market-container {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        grid-template-rows: repeat(2, 1fr);
        gap: 7px;
    }

    .market-resolved {
        background-color:#17783b;
        border: none;
        border-radius: 15px;
        padding: 7px;
        color:#ffffff;
        max-height: 15px;
    }

    .winning-outcome-container {
        display: flex;
        justify-content: space-between;
        color:#ffffff;
    }
    .market-unresolved {
        background-color:#7e2525;
        border: none;
        border-radius: 15px;
        padding: 7px;
        color:#ffffff;
        max-height: 15px;
    }
</style>