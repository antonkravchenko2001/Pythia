<template>
  <NavBar />
  <HomeContent />
</template>

<script>
import HomeContent from '../components/HomeContent/HomeContent.vue'
import NavBar from '@/components/NavBar/NavBar.vue'
import { checkChain } from '@/utils';

export default {
  components: {
    HomeContent,
    NavBar
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