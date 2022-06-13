
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
    box-shadow: 0.1px 0.1px 5px #121212;
  }

  textarea {
    box-shadow: 0.1px 0.1px 5px #121212;
  }

  input:focus{
    outline: 1.5px;
    outline-color: #2968a7;
    outline-style: solid;
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
  }

  #app {
    height: 100%;
  }
</style>
