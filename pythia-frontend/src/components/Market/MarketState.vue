<template>
    <div v-if="marketData.marketInfo.resolved">
        <span class="market-state-container" style="font-size:14pxp;justify-content:space-between;">
            <span class="winning-outcome-container">
                <span style="font-size:13px;color:#a3b7ce;font-weight:300">Correct answer:</span>
                 <span style="font-size:13px;color:white;font-weight:400">{{
                    marketData.marketInfo.winningOutcome <= 0 ? 'No' : 'Yes'
                 }}</span>
            </span>
            <div class="market-resolved">Resolved</div>
        </span>
        <span class="winning-outcome-container">
            <span style="font-size:13px;color:#a3b7ce;font-weight:300">Resolution price:</span>
            <span style="font-size:13px;color:white;font-weight:400">{{round(marketData.marketInfo.resolutionPrice)}}</span>
        </span>
    </div>
    <div v-if="!marketData.marketInfo.resolved" class="market-state-container" style="justify-content:flex-end;">
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
        },
        computed: {
            getWinOutcome(){
                if(this.marketData.marketInfo.winningOutcome === 0){
                    return 'No';
                }else{
                    return 'Yes';
                }
            }
        }
    };
</script>

<style scoped>
    .market-state-container {
        display: flex;
    }

    .resolved-market-container {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        grid-template-rows: repeat(2, 1fr);
        gap: 7px;
    }

    .market-resolved {
        background-color: #17783b;
        display: flex;
        justify-content: center;
        align-items: center;
        border-radius: 15px;
        padding: 5px;
        width: 90px;
        display: flex;
        justify-content: center;
        color: #ffffff;
    }

    .winning-outcome-container {
        display: flex;
        justify-content: space-between;
        width:max-content;
        color:#ffffff;
        gap: 4px;
    }
    .market-unresolved {
        background-color:#7e2525;
        display: flex;
        justify-content: center;
        align-items: center;
        border: none;
        border-radius: 15px;
        width: 90px;
        padding: 7px;
        color:#ffffff;
        max-height: 15px;
    }
</style>