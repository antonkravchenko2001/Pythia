<template>
  <div :class="{'scroll-disable': $store.state.showForm}">
    <NavBar />
    <HomeContent />
    <FooterComp />
  </div>
</template>

<script>
import HomeContent from '../components/HomeContent/HomeContent.vue'
import NavBar from '@/components/NavBar/NavBar.vue'
import { defineAsyncComponent } from 'vue'

export default {
  components: {
    HomeContent,
    NavBar,
    FooterComp: defineAsyncComponent(() =>
      import('../components/Footer/FooterComponent.vue')
    ),
  },
}
</script>


<style>
    .scroll-disable {
        overflow: hidden;
        height: 100vh;
    }
    
</style>