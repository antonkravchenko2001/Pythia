<template>
    <div>
        <i @click='show=true' v-if='!show' class="fa-solid fa-circle-info" style="top:25%; position:relative"></i>
        <div :style="{'background': background, 'width': width, 'height': height, 'position':'absolute'}" v-if='show' class="popup">
            {{text}}
            <button @click='show=false' class="close-button">close</button>
        </div>
    </div>
</template>

<script>
    export default {
        props: ['text', 'background', 'width', 'height'],
        data(){
            return {
                show: false
            };
        },
    }
</script>


<style scoped>

    .popup{
        padding: 5px;
        border: none;
        border-radius: 5px;
        box-shadow: 1px 1px 5px #121212;
        font-weight: 200;
        color: #ffffff;
        display: grid;
        grid-template-rows: repeat(2,max-content);
        gap: 20px;
        z-index: 20;

    }

    .close-button {
        border: none;
        padding: 5px;
        border-radius: 7px;
        background: #4d3ba7;
        box-shadow: 1px 1px 5px #121212;
        color: #ffffff;
    }
    .fa-circle-info {
        color: white;
        cursor: pointer;
    }
</style>