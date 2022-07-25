<template>
    <div class="create-market-div">
        <span style="position:relative">
            <button :disabled="!isLoggedIn" @click="click" class="create-market-button" :class="{'inactive-button': !isLoggedIn}">
                CREATE MARKET
            </button>
            <span style="left: 170px; top: 37%;position: absolute;">
                <PopUpWindow 
                    text='Connect wallet and create your own market so that others can check verify expertise by waging money on it' 
                    background="#121f2a"
                    color="#afafaf"
                    width="150px"
                    height="90px"
                />
            </span>
        </span>
    </div>
</template>

<script>
import { defineAsyncComponent } from 'vue'
export default {
    components: {
        PopUpWindow: defineAsyncComponent(() =>
            import('../subcomponents/PopUpWindow.vue')
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
        position: relative;
        z-index: 5;
    }

    .create-market-button{
        border-radius: 5px;
        border: none;
        background-color: #1d8e74dc;
        color: #ffffff;
        font-size: 14px;
        padding: 20px;
        font-family: 'Montserrat';
    }
    .create-market-button:active{
        background-color: #125b4adc;
    }

    .inactive-button {
        filter: brightness(40%);
        pointer-events: none;
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