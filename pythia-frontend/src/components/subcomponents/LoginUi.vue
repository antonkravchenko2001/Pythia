<template>
    <button v-if="!isLoggedIn" @click="logIn" class="login-button" style="height:35px">
      <i class="fa-solid fa-wallet"></i>
      Connect Wallet
    </button>
    <div v-if="isLoggedIn" class="login-container">
       <span class="expert-score-display">
        {{expertLevel}}
       </span>
       <button 
        style="position: relative;right: 0px;top: 0px;height: 100%;"
        @click="logOut"
        class="login-button">
        <i class="fa-solid fa-wallet"></i>
        Disconnect
      </button>
    </div>
</template>

<script>
import {determineExpertise} from '../../utils.js'
import Moralis from '../../main.js'

export default {
  data(){
    return {
      expertLevel: 'Novice'
    }
  },
  methods: {
    async logIn(){
      await Moralis.authenticate();
      await this.$store.commit('logIn');
      let player = this.$store.state.user.get('ethAddress');
      this.expertLevel = await determineExpertise(player);
    },
    async logOut(){
      await Moralis.User.logOut();
      await this.$store.commit('logOut')


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

};
</script>

<style scoped>

 .login-container {
    display:flex;
    justify-content: space-between;
    position: relative;
    background-color: #C0DDFF;
    gap: 10px;
    height: 35px;
    border-radius: 15px;
 }

 .login-button {
    background: #ffffff;
    color: #000000;
    border: none;
    border-radius: 15px;
    font-size: 14px;
    min-width:160px;
}

 .login-button:hover{
   background-color: #a0a0a0;
 }

 .expert-score-display{
    color: #3c3ab1;
    height: 100%;
    display: flex;
    align-items: center;
    font-size: 13px;
    padding-left: 10px;
    font-family: system-ui;
    font-weight: 650;
 }
</style>