<template>
    <div class="nav-bar">
       <div v-if="!isHome">
           <NavButton path='/' text='Home' />
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
import NavButton from './subcomponents/NavButton.vue'
import LoginUi from './subcomponents/LoginUi.vue'

    export default {

        computed: {
            isLoggedIn(){
                console.log(this.$store);
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
        justify-content: flex-end;
        background-color:  #0d1820;
        padding-left: 10px;
        padding-right: 10px;
    }
</style>