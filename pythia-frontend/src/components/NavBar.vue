<template>
    <div class="nav-bar">
       <div v-if='!isHomePage'>
           <NavButton path='/' text='Home' />
       </div>
       <div>
           <NavButton path='my-wages' text='Portfolio'/>
       </div>
       <div>
           <NavButton path='about' text='About'/>
       </div>
       <div>
           <LoginUi/>
       </div>
    </div>
</template>

<script>
import NavButton from './NavButton.vue'
import LoginUi from './LoginUi.vue'

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
    NavButton,
    LoginUi,
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