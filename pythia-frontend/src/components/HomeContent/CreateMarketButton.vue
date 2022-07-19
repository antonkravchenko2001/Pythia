<template>
    <div class="create-market-div">
        <span style="position:relative">
            <button  v-if='isLoggedIn' @click="click" class="create-market-button">
                CREATE MARKET
            </button>
            <span v-if='isLoggedIn' style="left: 170px; top: 37%;position: absolute;">
                <PopUpWindow 
                    text='Create your own market so that other can check verify expertise by weging money on it' 
                    background="#121f2a"
                    color="#afafaf"
                    width="150px"
                    height="70px"
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
    .create-market-button:hover{
        background-color: #125b4adc;
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