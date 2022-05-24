
<template>
  <LoginUi />
  <CreateMarket />
</template>

<script>
import LoginUi from './components/LoginUi.vue'
import CreateMarket from './components/CreateMarket.vue'

export default {
    name: 'App',
    components: {
      LoginUi,
      CreateMarket
    }
}
</script>