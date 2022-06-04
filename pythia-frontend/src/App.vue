
<template>
  <router-view/>
</template>

<style>
  html, body {
    height: 100vh;
    background-color: #0e2438;
    margin:0px;
    font-family: ui-sans-serif;
  }

  input:focus{
    outline: 1.5px;
    outline-color: #2968a7;
    outline-style: solid;
  }

  textarea {
    background: #243b53;
    border: none;
    border-radius: 5px;
    box-shadow: 0.5px 0.5px 5px #121212;
    padding: 7px;
    font-size: 14px;
    color: #cecece;
    font-family: sans-serif;
    font-size: 13px;
  }

  
  textarea:focus{
    outline: 1.5px;
    outline-color: #2968a7;
    outline-style: solid;
  }

  button{
    font-family: 'Montserrat';
    font-weight: 450;
  }
</style>
