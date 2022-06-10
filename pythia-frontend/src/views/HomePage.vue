<template>
  <NavBar />
  <HomeContent />
</template>

<script>
import HomeContent from '../components/HomeContent.vue'
import NavBar from '@/components/NavBar.vue'

export default {
  components: {
    HomeContent,
    NavBar
}
}
</script>