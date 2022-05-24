import {createApp} from 'vue'
import App from './App.vue'
import Moralis from 'moralis'
import {serverUrl, appId} from './config.js'


Moralis.start({ serverUrl, appId });

export default Moralis;

createApp(App).mount('#app')
