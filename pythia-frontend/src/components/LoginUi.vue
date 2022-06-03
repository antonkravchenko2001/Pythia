<template>
    <button v-if="!isLoggedIn" @click="logIn" class="login-button">Connect Wallet</button>
    <button v-if="isLoggedIn" @click="logOut" class="login-button">Disconnect</button>
</template>

<script>

export default {
  methods: {
    async logIn(){
      await this.$store.commit('logIn')
      console.log('logged in')
    },
    async logOut(){
      await this.$store.commit('logOut')
      console.log('logged out');

    }
  },
  computed: {
    isLoggedIn(){
      console.log(this.$store);
      if(this.$store.state.user){
        return true;
      }
      return false;
    }
  }

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