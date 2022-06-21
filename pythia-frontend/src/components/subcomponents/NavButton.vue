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
    color: #cecece;
    border: None;
    font-size: 13px;
    font-family: 'MontSerrat';
    font-weight: 450;
 }

 .home-button:hover{
     background-color: #1b4870;
     color: #121212;
 }

</style>