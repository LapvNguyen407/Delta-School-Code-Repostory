<template>
  <div id="login" class="text-center">
    <form class="form-signin" @submit.prevent="login">
      <h1 class="h3 mb-3 font-weight-normal">Please Sign In</h1>

      <div class="alert alert-danger" role="alert" v-if="invalidCredentials">
        Invalid username and password!
      </div>

      <div
        class="alert alert-success"
        role="alert"
        v-if="this.$route.query.registration"
      >
        Thank you for registering, please sign in.
      </div>

      <div id="username">
        <!-- <label for="username" class="sr-only">Username</label> -->
        <input
          type="text"
          id="username"
          class="form-control"
          placeholder="Username"
          v-model="user.username"
          required
          autofocus
        />
      </div>

      <div id="password">
        <!-- <label for="password" class="sr-only">Password</label> -->
        <input
          type="password"
          id="password"
          class="form-control"
          placeholder="Password"
          v-model="user.password"
          required
        />
      </div>

      <router-link :to="{ name: 'register' }" class="register"
        >Need an account?</router-link
      >

      <button type="submit">Sign in</button>
    </form>
  </div>
</template>

<script>
import authService from "../services/AuthService";
import emailService from "@/services/EmailService"

export default {
  name: "login",
  components: {},
  data() {
    return {
      user: {
        username: "",
        password: "",
      },
      invalidCredentials: false,
    };
  },
  methods: {
    login() {
      authService
        .login(this.user)
        .then((response) => {
          if (response.status == 200) {
            this.$store.commit("SET_AUTH_TOKEN", response.data.token);
            this.$store.commit("SET_USER", response.data.user);
            emailService.getSubscribers().then(response => {
              this.$store.commit("SET_SUBSCRIBERS", response.data);
            })
            this.$router.push("/");
          }
        })
        .catch((error) => {
          const response = error.response;

          if (response.status === 401) {
            this.invalidCredentials = true;
          }
        });
    },
  },
};
</script>

<style>
h1 {
  display: flex;
  justify-content: center;
}

#username {
  margin: 20px;
}

#password, #confirmPassword {
  margin: 20px;
}

.text-center {
  display: flex;
  align-content: center;
  justify-content: center;
}

form {
  display: inline-flex;
  flex-direction: column;
  align-content: center;
  justify-content: center;
}

.register {
  align-self: center;
  font-size: 20px;
  margin: 20px;
}
</style>