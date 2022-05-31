<template>
  <NavBar />
  <WageMoney />
</template>

<script>
import WageMoney from '../components/WageMoney.vue'
import NavBar from '@/components/NavBar.vue'

export default {
    components: {
      WageMoney,
      NavBar
    }
}
</script>