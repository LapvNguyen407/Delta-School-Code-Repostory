import Vue from 'vue'
import Router from 'vue-router'
import Login from '../views/Login.vue'
import Logout from '../views/Logout.vue'
import Register from '../views/Register.vue'
import Example from '../views/Example.vue'
import store from '../store/index'
import NotFound from '@/components/NotFound.vue'
import home from '@/views/Home'
import SubmitExample from '@/components/SubmitExample'
import UserExamples from '@/components/UserExamples'
import AdminPage from '@/components/AdminPage'

Vue.use(Router)

/**
 * The Vue Router is used to "direct" the browser to render a specific view component
 * inside of App.vue depending on the URL.
 *
 * It also is used to detect whether or not a route requires the user to have first authenticated.
 * If the user has not yet authenticated (and needs to) they are redirected to /login
 * If they have (or don't need to) they're allowed to go about their way.
 */

const router = new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: home,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/login",
      name: "login",
      component: Login,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/logout",
      name: "logout",
      component: Logout,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/register",
      name: "register",
      component: Register,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/example/:id",
      name: "example",
      component: Example,
      meta: {
        requiresAuth: false
      },
    },
    {
      path: "/example/user/private/:id",
      name: "private-example",
      component: Example,
      meta: {
        requiresAuth: true
      },
    },
    {
      path: "/example/user/pending/:id",
      name: "pending-example",
      component: Example,
      meta: {
        requiresAuth: true
      },
    },
    {
      path: "/submit",
      name: "submit",
      component: SubmitExample,
      meta: {
        requiresAuth: true
      },
    },
    {
      path: "/user",
      name: "user",
      component: UserExamples,
      meta: {
        requiresAuth: true
      },
    },
    {
      path: "/admin",
      name: "admin",
      component: AdminPage,
      meta: {
        requiresAuth: true
      },
    },
    {
      path: '/404', name: 'NotFound', component: NotFound
    },
    {
      path: '/:catchAll(.*)', redirect: '404'
    }
  ]
})

router.beforeEach((to, from, next) => {
  // Determine if the route requires Authentication
  const requiresAuth = to.matched.some(x => x.meta.requiresAuth);

  // If it does and they are not logged in, send the user to "/login"
  if (requiresAuth && store.state.token === '') {
    next("/login");
  } else {
    // Else let them go to their next destination
    next();
  }
});

export default router;
