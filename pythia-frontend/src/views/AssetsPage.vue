<template>
    <div>
        <NavBar/>
        <DisplayAssets/>
    </div>
</template>

<script>
   import NavBar from '@/components/NavBar/NavBar.vue'
   import DisplayAssets from '@/components/DisplayAssets.vue'

   export default {
        components:{
            NavBar,
            DisplayAssets
        }
   }
</script>