import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

/*
 * The authorization header is set for axios when you login but what happens when you come back or
 * the page is refreshed. When that happens you need to check for the token in local storage and if it
 * exists you should set the header so that it will be attached to each request
 */
const currentToken = localStorage.getItem('token')
const currentUser = JSON.parse(localStorage.getItem('user'));
const subscriptions = JSON.parse(localStorage.getItem('subscriptions'));

if (currentToken != null) {
  axios.defaults.headers.common['Authorization'] = `Bearer ${currentToken}`;
}

export default new Vuex.Store({
  state: {
    token: currentToken || '',
    user: currentUser || {},
    subscriptions: subscriptions || [],
    examples: [],
    userExamples: [],
    filterData: {
      titleFilter: '',
      languageFilter: '',
      tagFilter: [],
      imageUrl: '',
    },
    selectedExample: {
      example_id: 0,
      title: "default",
      language: "default",
      description: "default",
      code: "default",
      userId: 0,
      attribution: "default",
      submittedBy: "default"
    }
  },
  mutations: {
    SET_USER_EXAMPLES(state, examples) {
      state.userExamples = examples
    },
    CREATE_SELECTED_EXAMPLE(state, example) {
      state.selectedExample = example
      state.filterData.languageFilter = example.language;
    },
    SET_SUBMITTED_BY(state, username){
      state.selectedExample.submittedBy = username;
    },
    SET_FILTER_DATA(state, filterData) {
      state.filterData = filterData;
    },
    SET_EXAMPLES(state, examples) {
      state.examples = examples;
    },
    SET_SELECTED_LANGUAGE(state,language){
      state.filterData.languageFilter = language;
    },
    SET_AUTH_TOKEN(state, token) {
      state.token = token;
      localStorage.setItem('token', token);
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
    },
    SET_USER(state, user) {
      state.user = user;
      localStorage.setItem('user', JSON.stringify(user));
    },
    SET_SUBSCRIBERS(state, subs) {
      state.subscriptions = subs;
      localStorage.setItem('subscriptions', JSON.stringify(subs));
    },
    LOGOUT(state) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      localStorage.removeItem('subscriptions');
      state.token = '';
      state.user = {};
      axios.defaults.headers.common = {};
    }
  }
})
