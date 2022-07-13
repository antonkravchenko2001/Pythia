<template>
    <div v-if="marketData.marketInfo.resolved">
        <span class="market-state-container">
            <span class="winning-outcome-container" style="font-size:14px">
                Correct answer: {{getWinOutcome}}
            </span>
            <div class="market-resolved">Resolved</div>
        </span>
        <span class="winning-outcome-container"  style="font-size:12px;color:grey">
            Resolution price: {{round(marketData.marketInfo.resolutionPrice)}}
        </span>
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
        justify-content: space-between;
    }

    .resolved-market-container {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        grid-template-rows: repeat(2, 1fr);
        gap: 7px;
    }

    .market-resolved {
        background-color: #17783b;
        border-radius: 15px;
        padding: 5px;
        width: 70px;
        display: flex;
        justify-content: center;
        color: #ffffff;
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