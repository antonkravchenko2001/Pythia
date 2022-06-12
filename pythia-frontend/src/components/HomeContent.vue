<template>
    <div class='outer-container'>
        <div class="home-content-container">
            <CreateMarket />
            <MarketsDashboard/>
        </div>
    </div>
</template>

<script>
import CreateMarket from './subcomponents/CreateMarket.vue'
import MarketsDashboard from './subcomponents/MarketsDashboard.vue'

export default {
    components :{
        CreateMarket,
        MarketsDashboard
    }
}
</script>

<style scoped>
   .outer-container {
       display: flex;
       justify-content: center;
       height: 100%;
    }
   
   .home-content-container {
       width: 75%;
       height: 100%;

    }
</style>