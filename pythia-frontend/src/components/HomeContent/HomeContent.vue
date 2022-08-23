<template>
    <div style="display:flex; justify-content:center; height: max-content;position:relative;margin-top:81px;margin-bottom:100px">
        <div class='home-content' :class="{'blur-class': condition}">
            <span style="display:flex;flex-direction:column;gap:10px">
                <h1 class="title">
                    Available markets
                </h1>
                <h3 class="description" style="width:50%">
                    Predict events by waging money on available markets below or create your own to validate
                    other's expertise
                </h3>
            </span>
            <MarketsDashboard :assetNames='assetNames'/>
        </div>
    </div>
    <CreateMarketForm v-if="$store.state.showForm" :assetNames="assetNames"/>
</template>

<script>
import { defineAsyncComponent } from 'vue'
import MarketsDashboard from './MarketsDashboard.vue'
import Moralis from '../../main.js'

export default {
    components :{
        CreateMarketForm: defineAsyncComponent(() =>
            import('./CreateMarketForm.vue')
        ),
        MarketsDashboard
    },
    data(){
        return {
            assetNames: []
        }
    },
    methods: {
        async loadAssets(){
            const assets = await Moralis.Cloud.run('getAssets');
            const assetNames = [];
            for(let asset of assets){
                assetNames.push(asset.get('asset').toUpperCase())
            }
            return assetNames;
        }
    },
    watch: {
        '$store.state.user': function(newVal){
            if(!newVal){
                this.$store.state.showForm = false;
            }
        }
    },
    computed: {
        condition(){
            return (
                this.$store.state.showForm &&
                this.$store.state.user
            );
        }
    },
    async created(){
        this.assetNames = await this.loadAssets();
    }
}
</script>

<style scoped>

    .home-content{
        display: grid;
        grid-template-rows: repeat(3, max-content);
        gap: 25px;
        z-index:10;
    }

    .blur-class {
        filter: blur(8px) brightness(40%);
    }

    .title{
        text-align:left;
        color: #ffffff;
        font-family: 'Montserrat';
        font-size: 32px;
        font-weight:500;
        margin: 0px;
    }

    .description{
        text-align:left;
        color: #e8e3fd;
        font-family: 'Montserrat';
        font-weight:300;
        font-size: 15px;
        margin: 0px;
    }

    .alert{
        position: absolute;
        width:max-content;
        right:5px;
        z-index:100;
        top: 0px;
    }

    @media only screen and (max-width: 1000px) {
        .home-content {
            width: 95%;
        }
    }

    @media only screen and (min-width: 1001px) {
        .home-content {
            width: 85%;
        }
    }

    @media only screen and (min-width: 1200px) {
        .home-content {
            width: 80%;
        }
    }
</style>