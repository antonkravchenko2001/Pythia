<template>
    <div style="display:flex; justify-content:center; height: 85vh;" :class="{'scroll-disable': $store.state.showForm}">
        <div class='home-content' :class="{'blur-class': condition}">
            <span>
                <h1 class="platform-description" style="font-size:48px">
                    Pythia
                </h1>
                <h3 class="platform-description" style='font-size:24px'>
                    Harness Crypto technology to automate expert indentification
                </h3>
            </span>
            <CreateMarketButton :assetNames='filters.assetNames'/>
            <MarketsDashboard
                    :assetNames='filters.assetNames'
                    :volumeOptions='filters.volumeOptions'
                    :wageDeadlineOptions="filters.wageDeadlineOptions"
            />
        </div>
        <div v-if="$store.state.showForm" style="height: 88vh">
            <CreateMarketForm :assetNames="filters.assetNames.slice(1)"/>
        </div>
        <div v-if="!$store.state.chainCorrect">
            <Alert background='#ff000080' color='white' message='Error:' text='Incorrect network, please switch to Kovan'/>
        </div>
    </div>
</template>

<script>
import { defineAsyncComponent } from 'vue'
import CreateMarketButton from './CreateMarketButton.vue'
import MarketsDashboard from './MarketsDashboard.vue'
import Moralis from '../../main.js'

export default {
    components :{
        CreateMarketButton,
        CreateMarketForm: defineAsyncComponent(() =>
            import('./CreateMarketForm.vue')
        ),
        Alert: defineAsyncComponent(() =>
            import('../subcomponents/AlertWindow.vue')
        ),
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
            let nextDay = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 2);
            nextDay.setUTCHours(12,0,0,0);
            let thisWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 8);
            thisWeek.setUTCHours(12,0,0,0);
            let thisMonth = new Date(today.getFullYear(), today.getMonth() + 1, today.getDate() + 1);
            thisMonth.setUTCHours(12,0,0,0);
            return {
                'All': 'All',
                '24h': nextDay,
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
            console.log('wagedeadline options', this.filters.wageDeadlineOptions);
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
        await this.getFilters();
    }
}
</script>

<style scoped>

    .home-content{
        width: 75%;
        display: grid;
        grid-template-rows: repeat(3, max-content);
        gap: 25px;
        z-index:10;
    }

    .blur-class {
        filter: blur(8px) brightness(40%);
    }

    .platform-description{
        text-align:left;
        color: #ffffff;
        font-family: Arial, Helvetica, sans-serif;
        font-weight:800;
        margin: 0px;
        text-shadow: 2px 2px #3f189a;
    }

    .scroll-disable {
        overflow: hidden;
    }
</style>