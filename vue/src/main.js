import Vue from 'vue'
import App from './App.vue'
import router from './router/index'
import store from './store/index'
import axios from 'axios'


Vue.config.productionTip = false

import { initializeApp } from 'firebase/app';

// TODO: Replace the following with your app's Firebase project configuration
const firebaseConfig = {
  apiKey: "AIzaSyC24Dh9Or4ihkYlS3Hh8JG0i2EL2we9V7s",
  authDomain: "deltaschools-30b88.firebaseapp.com",
  projectId: "deltaschools-30b88",
  storageBucket: "deltaschools-30b88.appspot.com",
  messagingSenderId: "692025477345",
  appId: "1:692025477345:web:25382434b53eb4f1394fa0",
  measurementId: "G-QR7P43143D"
};

const app = initializeApp(firebaseConfig);
app

axios.defaults.baseURL = process.env.VUE_APP_REMOTE_API;

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
