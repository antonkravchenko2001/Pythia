<template>
  <NavBar />
  <MarketDisplay />
</template>

<script>
import MarketDisplay from '../components/MarketInfo/MarketDisplay.vue'
import NavBar from '@/components/NavBar/NavBar.vue'

export default {
    components: {
      MarketDisplay,
      NavBar
    }
}
</script>