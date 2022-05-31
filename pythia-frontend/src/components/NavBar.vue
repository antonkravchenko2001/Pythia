<template>
    <div class="nav-bar">
       <div v:if="!isHomePage">
           <HomeButton/>
       </div>
       <div>
           <AboutButton/>
       </div>
       <div>
           <LoginUi/>
       </div>
    </div>
</template>

<script>
import AboutButton from './AboutButton.vue';
import HomeButton from './HomeButton.vue';
import LoginUi from './LoginUi.vue';

    export default {
        data(){
            return {
                isHomePage: this.isHome(),
            }
        },
        methods :{
            isHome() {
                let page = this.$route.name;
                let isHome = (page === 'home');
                console.log(isHome);
                return isHome;
            }
        },
        components: {
            AboutButton,
            HomeButton,
            LoginUi
        }
    }
</script>

<style scoped>
    
    .nav-bar {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        background-color:  #0d1820;
        padding-left: 10px;
        padding-right: 10px;
    }
</style>