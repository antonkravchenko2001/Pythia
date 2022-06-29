<template>
    <div class="nav-bar">
       <div class="protocol-name-container">
            <img src="../../public/pythia-providence-eye.svg" width='60' height='60' fill="none"/>
       </div>
       <div class="nav-bar-inner">
            <div v-if="!isHome">
                <NavButton path='/' text='Home' />
            </div>
            <div>
                 <NavButton path='/leaderboard' text='Leaderboard'/>
            </div>
            <div>
                <NavButton path='/assets' text='Assets'/>
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
import NavButton from './subcomponents/NavButton.vue'
import LoginUi from './subcomponents/LoginUi.vue'

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
        }
    }
</script>

<style scoped>
    
    .nav-bar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color:  #0d1820;
        padding-left: 10px;
        padding-right: 10px;
        box-shadow: 1px 1px 8px #000000;
    }

    .nav-bar-inner {
        display: flex;
        justify-content: flex-end;
    }

    .protocol-name-container{
        display: flex;
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