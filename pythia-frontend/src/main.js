import {createApp} from 'vue'
import App from './App.vue'
import Moralis from 'moralis'
import {serverUrl, appId} from './config.js'
import router from './router'


Moralis.start({ serverUrl, appId });

export default Moralis;

createApp(App).use(router).mount('#app')
