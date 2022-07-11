<template>
    <div>
        <i @click='show=true' v-if='!show' class="fa-solid fa-circle-info" style="top:25%; position:relative"></i>
        <span :style="{'background': background, 'width': width, 'height': height, 'position':'absolute'}" v-if='show' class="popup">
            {{text}}
            <i @click='show=false' class="fa-solid fa-circle-xmark"></i>
        </span>
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
        display: flex;
        justify-content: space-between;
        padding: 7px;
        font-size: 12px;
        border: none;
        border-radius: 5px;
        box-shadow: 1px 1px 5px #121212;
        font-weight: 300;
        color: #bebebe;
        font-family: 'Montserrat';
        z-index: 10;
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

    .fa-circle-xmark {
        cursor: pointer;
        font-size: 12px;
    }
</style>