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
    background: transparent;
    padding:10px;
    color: #ffffff;
    border: None;
    font-size: 13px;
    font-family: 'MontSerrat';
    font-weight: 450;
 }

 .home-button:hover{
     color: #4d7c9f;
 }

</style>