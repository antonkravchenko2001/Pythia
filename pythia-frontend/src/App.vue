
<template>
  <router-view/>
</template>

<style>
  html, body {
    height: 100vh;
    background: #0b1f2e;
    background: linear-gradient(90deg, rgba(11,31,46,1) 0%, rgba(9,25,39,1) 53%, rgba(15,38,58,1) 100%);
    margin:0px;
    font-family: ui-sans-serif;
  }

  input {
    padding: 5px;
  }

  input:focus{
    outline: 1.5px;
    outline-color: #2968a7;
    outline-style: solid;
  }

  input::placeholder{
    font-weight: 200;
    font-family: 'Montserrat';
    color:#bebebe;
  }

  textarea {
    padding: 5px
  }
  
  textarea:focus{
    outline: 1.5px;
    outline-color: #2968a7;
    outline-style: solid;
  }

  textarea::placeholder{
    font-weight: 200;
    font-family: 'Montserrat';
    color:#bebebe;
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


</style>
