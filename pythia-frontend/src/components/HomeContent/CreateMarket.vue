<template>
    <div class="create-market-div">
        <button  v-if="!clicked & isLoggedIn" @click="click" class="create-market-button">
            CREATE MARKET
            <i class="fas fa-plus"></i>
        </button>
        <div v-if="clicked & isLoggedIn">
            <CreateMarketForm :assetNames="assetNames"/>
        </div>
    </div>
</template>

<script>
import { defineAsyncComponent } from 'vue'
export default {
    components: {
         CreateMarketForm: defineAsyncComponent(() =>
            import('./CreateMarketForm.vue')
        )
    },
    props: ['assetNames'],
    data(){
        return {
            assets: this.assetNames
        }
    },
    methods: {
        click(){
            this.$store.state.showForm = true;
        },
    },
    computed: {
        isLoggedIn(){
            if(this.$store.state.user){
                return true;
            }
            return false;
        },
        clicked(){
            return this.$store.state.showForm;
        }
    }
}
</script>

<style scoped>
    .create-market-div {
        display: flex;
        max-height: 50vh;
        min-height: 20vh;
        width: 100%;
        justify-content: center;
        align-items: center;
        position: absolute;
        z-index: 5;
    }

    .create-market-button{
        border-radius: 5px;
        border: solid 2px #57c080dc;
        background-color: #0b1f2e;
        color: #ffffff;
        font-size: 14px;
        padding: 20px;
        font-family: 'Montserrat';
    }
    .create-market-button:hover{
        background-color: #35794fdc;
    }

    .fas {
        font-family: "Font Awesome 5 Pro";
        font-weight: 1000;
        left: 5px;
        top: 1px;
        position: relative;
        font-size: 20px;
    }
</style>