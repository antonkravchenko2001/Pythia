<template>
    <div class="platform-description" :class="{'blur-class': condition}">
        Pythia: harness Crypto technology to automate expert indentification
    </div>
    <CreateMarket :assetNames='filters.assetNames'/>
    <div class='outer-container' :class="{'blur-class': condition, 'scroll-disable': this.$store.state.showForm}">
        <div class="home-content-container">
            <MarketsDashboard
                :assetNames='filters.assetNames'
                :volumeOptions='filters.volumeOptions'
                :wageDeadlineOptions="filters.wageDeadlineOptions"
            />
        </div>
    </div>
</template>

<script>
import CreateMarket from './CreateMarket.vue'
import MarketsDashboard from './MarketsDashboard.vue'
import Moralis from '../../main.js'

export default {
    components :{
        CreateMarket,
        MarketsDashboard
    },
    data(){
        return {
            filters: {
                assetNames: [],
                volumeOptions: {},
                wageDeadlineOptions: {},
            }
        }
    },
    methods: {
        async loadAssets(){
            const assets = await Moralis.Cloud.run('getAssets');
            const assetNames = [];
            assetNames.push('All');
            for(let asset of assets){
                assetNames.push(asset.get('asset').toUpperCase())
            }
            return assetNames;
        },
        wageDeadlineOptions(){
            let today = new Date();
            today = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);
            let thisWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 7);
            let thisMonth = new Date(today.getFullYear(), today.getMonth() + 1, today.getDate());
            return {
                'All': 'All',
                '24h': today,
                'this week': thisWeek,
                'this month': thisMonth,
            };
        },
        async getFilters(){
            this.filters.assetNames = await this.loadAssets();
            this.filters.volumeOptions =  {
                'All': 'All',
                '> 100': 100,
                '> 1000': 1000,
                '> 10000': 100000
            }

            this.filters.wageDeadlineOptions = this.wageDeadlineOptions();
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
        await this.getFilters();
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

    .scroll-disable {
        overflow: hidden;
    }
</style>