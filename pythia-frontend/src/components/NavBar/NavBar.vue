<template>
    <div class="nav-bar">
        <span class="nav-bar-items">
            <div class="protocol-name-container">
                <div style="display:flex;justify-content:center;align-items:center;padding-right: 20px;">
                    <img src="../../../public/pythia-icon.svg" width='55' height='55' fill="none"/>
                    <h2 style="color:white;font-family:'Montserrat'">Pythia</h2>
                </div>
                <BetaVersionSymb/>
            </div>
            <div class="nav-bar-inner">
                <div v-if="!(this.$route.name === 'home')">
                    <NavButton path='/' text='Home' type='internal' />
                </div>
                <div v-if="!(this.$route.name === 'leaderboard')">
                    <NavButton path='/leaderboard' text='Leaderboard' type='internal'/>
                </div>
                <div>
                    <NavButton :path="'https://docs.pythia.company/'" text='User docs' type='external'/>
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
import BetaVersionSymb from './BetaVersionSymb.vue';

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
            BetaVersionSymb
        }
    }
</script>

<style scoped>
    
    .nav-bar {
        display: flex;
        align-items: center;
        justify-content: center;
        background:#07141f;
        margin-bottom: 10%;
    }

    .nav-bar-inner {
        display: flex;
        justify-content: flex-end;
    }

    .nav-bar-items{
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 97%;
        min-width: 80%;
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
</style>