<template>
    <div class="nav-bar">
        <span class="nav-bar-items">
            <div class="protocol-name-container">
                <div style="display:flex;justify-content:center;align-items:center;padding-right: 20px;">
                    <img src="../../../public/pythia-icon.svg" width='55' height='55' fill="none"/>
                    <h2 style="color:white;font-family:'Montserrat'">Pythia</h2>
                </div>
                <div>
                    <NavButton 
                        path='https://kovan.balancer.fi/#/trade/0xdfcea9088c8a88a76ff74892c1457c17dfeef9c1/0x04df6e4121c27713ed22341e7c7df330f56f289b'
                        text='Get Kovan Dai'
                        type='external'
                        fontweight='500'
                        fontsize="15px"
                    />
                </div>
            </div>
            <div class="nav-bar-inner">
                <div v-if="!(this.$route.name === 'home')">
                    <NavButton path='/' text='Home' type='internal' />
                </div>
                <div v-if="!(this.$route.name === 'leaderboard')">
                    <NavButton path='/leaderboard' text='Leaderboard' type='internal'/>
                </div>
                <div>
                    <NavButton :path="'https://docs.pythia.company/'" text='Docs' type='external'/>
                </div>
                <div style="display:flex; justify-content:center; align-items:center">
                    <LoginUi/>
                </div>
            </div>
        </span>
    </div>
</template>

<script>
import NavButton from './NavButton.vue'
import LoginUi from '../subcomponents/LoginUi.vue'

    export default {

        computed: {
            isLoggedIn(){
                if(this.$store.state.user){
                    return true;
                }
                return false;
            },
        },
        components: {
            NavButton,
            LoginUi,
        }
    }
</script>

<style scoped>
    
    .nav-bar {
        display: flex;
        align-items: center;
        justify-content: center;
        background: #0D1825;
    }

    .nav-bar-inner {
        display: flex;
        justify-content: flex-end;
    }

    .nav-bar-items{
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .protocol-name-container{
        display: flex;
        align-items: center;
    }

    .protocol-name {
        display: flex;
        justify-content: center;
        align-items: center;
        font-family: 'Montserrat';
        font-weight: 600;
        color: #b6b5ea;
        font-size: 18px;
    }

    @media only screen and (max-width: 1000px) {
        .nav-bar-items {
            width: 95%;
        }
    }

    @media only screen and (min-width: 1001px) {
        .nav-bar-items {
            width: 85%;
        }
    }

    @media only screen and (min-width: 1200px) {
        .nav-bar-items {
            width: 80%;
        }
    }
</style>