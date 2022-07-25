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
import { checkChain } from '@/utils';

export default {
  components: {
    HomeContent,
    NavBar,
    FooterComp: defineAsyncComponent(() =>
      import('../components/Footer/FooterComponent.vue')
    ),
  },
  computed: {
    correctChain(){
      if((this.$store.state.correctChain) || (!this.$store.state.user)){
        return true;
      }
      return false;
      
    }
  },
  async created(){
    let chainCorrect = await checkChain();
    this.$store.state.correctChain = chainCorrect;
    console.log(chainCorrect);
  }
}
</script>


<style>
    .scroll-disable {
        overflow: hidden;
        height: 100vh;
    }
    
</style>