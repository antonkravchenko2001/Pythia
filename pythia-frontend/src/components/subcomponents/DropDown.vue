<template>
    <div :style="{'background': background, 'color': 'white'}" class="drop-down-container">
        <div class="input" @click="press()">
            {{input}}
            <i class="fa-solid fa-caret-down"></i>
        </div>
        <div v-if="!selected" :style="{'height': height, 'background': background, 'z-index': '10'}" class="dropdown">
            <div  v-for="obj in objects"   :key="obj" @click="select(obj)" class="dropdown-el">{{obj}}</div>
        </div>
    </div>
</template>

<script>
    export default{
        props: ['defaultValue', 'objects', 'height', 'background'],
        data(){
            return {
                input: this.defaultValue,
                selected: true
            }
        },
        methods: {
            press(){
                if(this.selected){
                    this.selected = false;
                }else{
                    this.selected = true;
                }
            },
            select(obj){
                this.selected = true;
                this.input = obj;
            }
        }
    }
</script>


<style scoped>

    .drop-down-container {
        border: none;
        width: 100%;
        border-radius: 5px;
        font-family: 'Montserrat';
        font-size: 12px;
        position: relative;
        justify-content: space-between;
        box-shadow: 1px 1px 5px #121212;
    }
    .input {
        padding: 5px;
        display:flex;
        align-items: center;
        justify-content: space-between;
    }

    .dropdown{
        width: 100%;
        overflow: auto;
        overflow-x: hidden;
        position:absolute;
        border-radius: 5px;
        top: 32px;
        box-shadow: 1px 1px 5px #121212;
    }

    .dropdown-el{
        padding: 5px;
    }

    .dropdown-el:hover {
        background: rgb(9, 42, 72);
    }
</style>
