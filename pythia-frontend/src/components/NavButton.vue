<template>
    <button @click="$router.push(path)" class="home-button">{{text}}</button>
</template>

<script>
export default {
    props: ['path', 'text']
}
</script>

<style scoped>

 .home-button {
    background-color: #0d1820;
    padding: 25px;
    font: sans-serif;
    color: #cecece;
    border: None;
    font-size: 13px;
    font-family: sans-serif;
 }

 .home-button:hover{
     background-color: #406996;
     color: #121212;
 }

</style>