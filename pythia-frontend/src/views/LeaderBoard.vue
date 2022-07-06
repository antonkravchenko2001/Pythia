<template>
    <div>
        <NavBar/>
        <LeaderTable/>
    </div>
</template>

<script>
   import NavBar from '@/components/NavBar/NavBar.vue'
   import LeaderTable from '@/components/LeaderTable.vue'

   export default {
        components:{
            NavBar,
            LeaderTable
        }
   }
</script>