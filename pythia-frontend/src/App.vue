
<template>
  <router-view/>
</template>

<style>
  html, body {
    height: 100vh;
    background: linear-gradient(90deg, rgb(9, 25, 37) 0%, #06121c 53%, #0b1d2c 100%);
    margin:0px;
    font-family: ui-sans-serif;
  }

  input {
    padding: 5px;
  }

  input:focus{
    outline-style: none;
  }

  input::placeholder{
    font-weight: 300;
    font-family: 'Montserrat';
    color:#b2b2b2;
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
