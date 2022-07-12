<template>
    <div class="nav-bar">
       <div class="protocol-name-container">
            <div style="padding:5px">
                <img src="../../../public/pythia-providence-eye.svg" width='57' height='57' fill="none"/>
            </div>
            <BetaVersionSymb/>
       </div>
       <div class="nav-bar-inner">
            <div v-if="!isHome">
                <NavButton path='/' text='Home' />
            </div>
            <div>
                 <NavButton path='/leaderboard' text='Leaderboard'/>
            </div>
            <div>
                <NavButton path='/user-guide' text='User guide'/>
            </div>
            <div style="display:flex; justify-content:center; align-items:center">
                <LoginUi/>
            </div>
       </div>
    </div>
</template>

<script>
import NavButton from './NavButton.vue'
import LoginUi from './LoginUi.vue'
import BetaVersionSymb from './BetaVersionSymb.vue';

    export default {

        computed: {
            isLoggedIn(){
                if(this.$store.state.user){
                    return true;
                }
                return false;
            },
            isHome(){
                let isHome = (this.$route.name === 'home');
                return isHome;
            }
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
        justify-content: space-between;
        padding-left: 10px;
        padding-right: 10px;
    }

    .nav-bar-inner {
        display: flex;
        justify-content: flex-end;
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