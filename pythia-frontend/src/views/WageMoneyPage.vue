<template>
  <LoginUi />
  <WageMoney />
  <router-link to="/">Home</router-link>
</template>

<script>
import LoginUi from '../components/LoginUi.vue'
import WageMoney from '../components/WageMoney.vue'

export default {
    components: {
        LoginUi,
        WageMoney
    }
}
</script>