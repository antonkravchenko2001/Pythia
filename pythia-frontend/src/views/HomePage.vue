<template>
  <NavBar />
  <CreateMarket />
</template>

<script>
import CreateMarket from '../components/CreateMarket.vue'
import NavBar from '@/components/NavBar.vue'

export default {
    components: {
    CreateMarket,
    NavBar
}
}
</script>