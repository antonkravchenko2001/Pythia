<template>
    <div>
        <NavBar/>
        <LeaderTable/>
        <FooterComp/>
    </div>
</template>

<script>
   import NavBar from '@/components/NavBar/NavBar.vue'
   import { defineAsyncComponent } from 'vue'
   import LeaderTable from '@/components/LeaderTable.vue'

   export default {
        components:{
            NavBar,
            LeaderTable,
            FooterComp: defineAsyncComponent(() =>
                import('../components/Footer/FooterComponent.vue')
            ),
        }
   }
</script>