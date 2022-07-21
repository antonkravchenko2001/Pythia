import {createApp} from 'vue'
import App from './App.vue'
import Moralis from 'moralis'
import {serverUrl, appId} from './config.js'
import router from './router'
import { createStore } from 'vuex'


Moralis.start({ serverUrl, appId });

Moralis.onChainChanged(async function () {
  window.location.reload();
});

export default Moralis;


const store = createStore({
  state () {
    return {
      user: Moralis.User.current(),
      showForm: false,
      chainCorrect: true
    }
  },
  mutations: {
    async logIn(state) {
      state.user = Moralis.User.current();
    },
    async logOut(state) {
        state.user = null;
    },

  }
})

createApp(App)
.use(router)
.use(store)
.mount('#app')
