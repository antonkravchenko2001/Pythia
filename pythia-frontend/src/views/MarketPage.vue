<template>
  <NavBar />
  <MarketDisplay />
</template>

<script>
import MarketDisplay from '../components/Market/MarketDisplay.vue'
import NavBar from '@/components/NavBar/NavBar.vue'

export default {
    components: {
      MarketDisplay,
      NavBar
    }
}
</script>