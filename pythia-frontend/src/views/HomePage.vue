<template>
  <NavBar />
  <HomeContent />
</template>

<script>
import HomeContent from '../components/HomeContent/HomeContent.vue'
import NavBar from '@/components/NavBar/NavBar.vue'

export default {
  components: {
    HomeContent,
    NavBar
  }
}
</script>

<style scoped>
</style>