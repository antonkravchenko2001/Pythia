<template>
    <div :style="{'background': background, 'color': 'white'}" class="drop-down-container">
        <div class="input">
            {{input}}
            <i class="fa-solid fa-caret-down" @click="press()"></i>
        </div>
        <div v-if="!selected" :style="{'height': height, 'background': background, 'z-index': '10'}" class="dropdown">
            <div  v-for="obj in objects"   :key="obj" @click="select(obj)" class="dropdown-el">{{obj}}</div>
        </div>
    </div>
</template>

<script>
    export default{
        props: ['objects', 'height', 'background'],
        data(){
            return {
                input: '',
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
        background: rgb(45, 78, 135);
    }
</style>
