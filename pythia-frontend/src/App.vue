
<template>
  <router-view/>
</template>

<style>
  html, body {
    margin: 0;
    height: 100%;
    background-image: linear-gradient(151deg, #353535 20%, #212121 65%);
  }

  input {
    background: #454545;
    border: none;
    border-radius: 5px;
    box-shadow: 0.5px 0.5px 5px #121212;
    padding: 7px;
    
  }

  input:focus{
    outline: 1.5px;
    outline-color: #2968a7;
    outline-style: solid;
  }

  textarea {
    background: #454545;
    border: none;
    border-radius: 5px;
    box-shadow: 0.5px 0.5px 5px #121212;
    padding: 7px;
    font-size: 14px;
  }

  
  textarea:focus{
    outline: 1.5px;
    outline-color: #2968a7;
    outline-style: solid;
  }
</style>
