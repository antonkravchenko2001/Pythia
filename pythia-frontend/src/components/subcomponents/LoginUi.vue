<template>
    <button v-if="!isLoggedIn" @click="logIn" class="login-button" style="height:35px">
      <img src = "https://raw.githubusercontent.com/blakewood84/react-metamask/main/public/images/metamask.svg" alt="My Happy SVG" width='12' height='12'/>
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
        <img src = "https://raw.githubusercontent.com/blakewood84/react-metamask/main/public/images/metamask.svg" alt="My Happy SVG" width='12' height='12'/>
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
    background-color: #183362;
    gap: 10px;
    height: 35px;
    border-radius: 15px;
 }

 .login-button {
    background: #3a46c4;
    color: #ffffff;
    border: none;
    border-radius: 15px;
    font-size: 12px;
    min-width:135px;
}

 .login-button:hover{
   background-color: #3a46c4;
 }

 .expert-score-display{
    color: #4cd9b2;
    height: 100%;
    display: flex;
    align-items: center;
    font-size: 13px;
    padding-left: 10px;
    font-family: system-ui;
    font-weight: 650;
 }
</style>