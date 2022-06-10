<template>
  <NavBar />
  <MarketDisplay />
</template>

<script>
import MarketDisplay from '../components/MarketDisplay.vue'
import NavBar from '@/components/NavBar.vue'

export default {
    components: {
      MarketDisplay,
      NavBar
    }
}
</script>