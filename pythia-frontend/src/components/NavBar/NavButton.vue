<template>
    <div v-if="type == 'internal'">
        <button @click="$router.push(path)" class="home-button">{{text}}</button>
    </div>
    <div v-if="type == 'external'">
        <button 
            @click="open(path)"
            class="home-button"
            :style="{'font-size': fontsize, 'font-weight': fontweight}"
        >
            {{text}}
        </button>
    </div>
</template>

<script>
export default {
    props: ['path', 'text', 'type', 'fontsize', 'fontweight'],
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
    padding-right:30px;
    padding-top: 32.5px;
    padding-left: 10px;
    padding-bottom: 32.5px;
    color: #ffffff;
    border: None;
    font-size: 14px;
    font-family: 'MontSerrat';
    font-weight: 400;
 }

 .home-button:hover{
     color: #4d7c9f;
 }

</style>