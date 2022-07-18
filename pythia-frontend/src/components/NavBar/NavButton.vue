<template>
    <div v-if="type == 'internal'">
        <button @click="$router.push(path)" class="home-button">{{text}}</button>
    </div>
    <div v-if="type == 'external'">
        <button @click="open(path)" class="home-button">{{text}}</button>
    </div>
</template>

<script>
export default {
    props: ['path', 'text', 'type'],
    methods: {
        open(path){
            window.open(path, "_self");
        }
    },
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