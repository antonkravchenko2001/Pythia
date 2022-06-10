<template>
    <div class='outer-container'>
        <div class="home-content-container">
            <CreateMarket />
        </div>
    </div>
</template>

<script>
import CreateMarket from './subcomponents/CreateMarket.vue'

export default {
    components :{
        CreateMarket,
    }
}
</script>

<style scoped>
   .outer-container {
       display: flex;
       justify-content: center;
       height: 100%;
    }
   
   .home-content-container {
       background-color: #0d1c2b;
       width: 75%;
       height: 100%;

    }
</style>