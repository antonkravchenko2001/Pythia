<template>
    <button v-if="!user" @click="logIn" class="login-button">Connect Wallet</button>
    <button v-if="user" @click="logOut" class="login-button">Disconnect</button>
</template>

<script>
import Moralis from '../main.js';

export default {
  data(){
    return {
      user: Moralis.User.current()
    }
  },
  methods: {
    async logIn(){
      try{
        await Moralis.authenticate();
        this.user = Moralis.User.current();
      } catch(error){
        console.error(error);
      }
    },
    async logOut(){
      await Moralis.User.logOut();
      this.user = Moralis.User.current();
      console.log('logged out');

    }
  },

};
</script>

<style scoped>

 .login-button {
    background-color: #3ac4b4;
    color:#121212;
    border: solid 2px;
    border-color: #32978b;
    border-radius: 25px;
    font-size: 12px;
    font-family: sans-serif;
    padding: 8px;
 }

 .login-button:hover{
   background-color: #32978b;
 }
</style>