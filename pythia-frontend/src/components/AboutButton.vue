<template>
    <button @click="$router.push('about')" class="about-button">About</button>
</template>

<style scoped>

 .about-button {
    background-color: #0d1820;
    padding: 25px;
    font: sans-serif;
    color: #cecece;
    border: None;
    font-size: 13px;
    font-family: sans-serif;
 }

 .about-button:hover{
     background-color: #406996;
     color: #121212;
 }

</style>