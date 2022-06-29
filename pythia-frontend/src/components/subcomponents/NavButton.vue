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
    padding:10px;
    color: #ffffff;
    border: None;
    font-size: 14px;
    font-family: 'MontSerrat';
    font-weight: 450;
 }

 .home-button:hover{
     color: #4d7c9f;
 }

</style>