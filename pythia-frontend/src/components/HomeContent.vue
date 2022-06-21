<template>
    <CreateMarket />
    <div class='outer-container' :class="{'blur-class': $store.state.showForm}">
        <div class="home-content-container">
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
       top: 50%;
       position: relative;
    }

    .blur-class {
        filter: blur(5px);
    }
</style>