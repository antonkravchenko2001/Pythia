<template>
    <button v-if="!isLoggedIn" @click="logIn" class="login-button">
      <img src = "https://raw.githubusercontent.com/blakewood84/react-metamask/main/public/images/metamask.svg" alt="My Happy SVG" width='12' height='12'/>
      Connect Wallet
    </button>
    <button v-if="isLoggedIn" @click="logOut" class="login-button">
      <img src = "https://raw.githubusercontent.com/blakewood84/react-metamask/main/public/images/metamask.svg" alt="My Happy SVG" width='12' height='12'/>
      Disconnect
    </button>
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
    background-color: #3a46c4;
    box-shadow: 1px 1px 8px #121212;
    color: #ffffff;
    border: none;
    border-radius: 3px;
    font-size: 12px;
    padding: 8px;
    font-family: 'MontSerrat';
    font-weight: 450;
    z-index: 5;
    margin-left: 5px;
}

 .login-button:hover{
   background-color: #3a46c4;
 }
</style>