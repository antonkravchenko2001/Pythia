<template>
  <button v-if="!isAuthenticated" @click="logIn">Connect Wallet</button>
  <button v-if="isAuthenticated" @click="logOut">Disconnect</button>
</template>

<script>
import Moralis from '../main.js';

export default {
  data() {
    return  {
      isAuthenticated: false
    };
  },
  methods: {
    async logIn(){
      let user;
      try{
        user = await Moralis.authenticate();
        this.isAuthenticated = true;
        this.userAddress = user.get("ethAddress");
      } catch(error){
        console.error(error);
      }
    },
    async logOut(){
      await Moralis.User.logOut();
      this.isAuthenticated = false;
      console.log("logged out");
    }
  }
};
</script>

<style scoped>
</style>