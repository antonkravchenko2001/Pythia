<template>
    <div class="container-around">
        <div class="market-info-space">
            <MarketInfo/>
            <div class="state-and-buy-container">
                <MarketState/>
                <BuyShares/>
            </div>
        </div>
    </div>
</template>

<script>
import MarketInfo from './subcomponents/MarketInfo.vue'
import BuyShares from './subcomponents/BuyShares.vue'
import MarketState from './subcomponents/MarketState.vue'
export default {
    components: {
        MarketInfo,
        BuyShares,
        MarketState
    }

}
</script>

<style scoped>
    .container-around {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        font-family: 'Montserrat';
        font-weight: 400;
    }
    .market-info-space {
        display: grid;
        gap: 50px;
        grid-template-columns: 5fr 3fr;
        background-color: #0b1723;
        padding: 20px;
        box-shadow: 1px 1px 8px #121212;
    }

    .state-and-buy-container {
        display: grid;
        grid-template-rows: 1fr 2fr;
    }
</style>