import {createApp} from 'vue'
import App from './App.vue'
import Moralis from 'moralis'
import {serverUrl, appId} from './config.js'
import router from './router'
import { createStore } from 'vuex'


Moralis.start({ serverUrl, appId });

export default Moralis;


const store = createStore({
  state () {
    return {
      user: Moralis.User.current()
    }
  },
  mutations: {
    async logIn(state) {
      await Moralis.authenticate();
      state.user = Moralis.User.current();
    },
    async logOut(state) {
        await Moralis.User.logOut();
        state.user = Moralis.User.current();
    }

  }
})

createApp(App)
.use(router)
.use(store)
.mount('#app')
