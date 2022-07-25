<template>
  <NavBar />
  <MarketDisplay />
  <FooterComp />
</template>

<script>
import MarketDisplay from '../components/Market/MarketDisplay.vue'
import NavBar from '@/components/NavBar/NavBar.vue'
import { defineAsyncComponent } from 'vue'

export default {
    components: {
      MarketDisplay,
      NavBar,
      FooterComp: defineAsyncComponent(() =>
        import('../components/Footer/FooterComponent.vue')
      ),
    }
}
</script>