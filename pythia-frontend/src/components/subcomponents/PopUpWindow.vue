<template>
    <div>
        <i @click='show=true' v-if='!show' class="fa-solid fa-circle-info" style="top:25%; position:relative"></i>
        <span :style="{'background': background, 'color': color, 'width': width, 'height': height, 'position':'absolute'}" v-if='show' class="popup">
            {{text}}
            <i @click='show=false' class="fa-solid fa-circle-xmark"></i>
        </span>
    </div>
</template>

<script>
    export default {
        props: ['text', 'background', 'width', 'height', 'color'],
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
        font-family: 'Montserrat';
        z-index: 10;
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