
<template>
  <router-view/>
</template>

<style>
  html, body {
    height: 100vh;
    background-color: #0b1e2f;
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
    font-weight: 350;
    font-family: 'Montserrat';
  }

  textarea {
    padding: 5px
  }
  
  textarea:focus{
    outline: 1.5px;
    outline-color: #2968a7;
    outline-style: solid;
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

</style>
