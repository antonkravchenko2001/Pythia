
<template>
  <router-view/>
</template>


<script>
    import { checkChain } from './utils';
    export default {
      async created(){
          let chainCorrect = await checkChain();
          this.$store.state.chainCorrect = chainCorrect;
      },

    }
</script>


<style>
  html, body {
    height: 100%;
    width: 100%;
    overflow-x: hidden;
    padding: 0px;
    background:#0F1C2C;
    margin:0px;
    font-family: ui-sans-serif;
  }

  input {
    padding-left: 15px;
    padding-right: 15px;
    padding-top: 5px;
    padding-bottom: 4px;
  }

  input:focus{
    outline-style: none;
  }

  input::placeholder{
    font-weight: 300;
    font-family: Helvetica;
    color:#a3b7ce;
    font-size: 15px;
  }
  
  button{
    font-family: 'Montserrat';
    font-weight: 450;
    cursor: pointer;
    -moz-user-select: none;
    -khtml-user-select: none;
    -webkit-user-select: none;
    -ms-user-select: none;
    user-select: none;
  }

  div {
    -moz-user-select: none;
    -khtml-user-select: none;
    -webkit-user-select: none;
    -ms-user-select: none;
    user-select: none;
  }

  #app {
    height: 100%;
    width: 100%;
  }

  input::-webkit-outer-spin-button,
  input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }

  /* Firefox */
  input[type=number] {
    -moz-appearance: textfield;
  }

  div::-webkit-scrollbar {
    width: 5px;
    height:50px;
  }

  /* Track */
  div::-webkit-scrollbar-track {
    background: transparent;
    margin: 5px;
  }

  /* Handle */
  div::-webkit-scrollbar-thumb {
    background: #7aaae1;
    border-radius: 5px;
    height:40px;
  }

  div::-webkit-scrollbar-thumb:active{
    background: #062243;
  }

  ::-webkit-calendar-picker-indicator {
    filter: invert(1);
  }

  input[type="date"]::-webkit-calendar-picker-indicator {
    display: none  !important;
  }


</style>
