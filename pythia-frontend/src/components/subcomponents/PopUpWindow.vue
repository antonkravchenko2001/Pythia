<template>
    <div>
        <i @click='show=true' class="fa-solid fa-circle-info"></i>
        <span :style="{'background': background, 'color': color, 'width': width, 'height': height}" v-if='show' class="popup">
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
        position: absolute;
        top:0px;
        right: 0px;
    }

    .fa-circle-info {
        font-size: 14px;
        color: white;
        cursor: pointer;
    }

    .fa-circle-xmark {
        cursor: pointer;
        font-size: 12px;
    }
</style>