<template>
    <div class="platform-description" :class="{'blur-class': condition}">
        Pythia: harness Crypto to automate expert indentification
    </div>
    <CreateMarket />
    <div class='outer-container' :class="{'blur-class': condition}">
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
    },
    computed: {
        condition(){
            return (
                this.$store.state.showForm &&
                this.$store.state.user
            );
        }
    }
}
</script>

<style scoped>
   .outer-container {
       display: flex;
       justify-content: center;
       height: 50%;
    }
   
   .home-content-container {
       width: 75%;
       height:0%;
       top: 50%;
       position: relative;
    }

    .blur-class {
        filter: blur(5px);
    }

    .platform-description{
        display: flex;
        flex-wrap: wrap;
        text-align:center;
        width: 80%;
        margin-left: 10%;
        margin-top: 5%;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        color: #ffffff;
        font-size: 48px;
        font-family: Arial, Helvetica, sans-serif;
        font-weight:800;
        text-shadow: 2px 2px #3f189a;
    }
</style>