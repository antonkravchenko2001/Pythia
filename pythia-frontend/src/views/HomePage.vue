<template>
  <LoginUi />
  <router-link to='/create-market'>create market</router-link>
  <router-link to='/markets/0'>wage money</router-link>
</template>

<script>
import LoginUi from '../components/LoginUi.vue'
export default {
    components: {
      LoginUi
  }
}
</script>