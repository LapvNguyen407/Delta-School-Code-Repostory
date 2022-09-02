<template>
  <div class="main">
    <img
      id="logo-image"
      src="../../resources/DeltaSchoolLogo.png"
      alt="Delta School Logo"
      v-on:click="$router.push({ name: 'home' })"
    />

    <div id="not-logo">
      <!-- User page -->
      <router-link
        class="userPage"
        v-bind:to="{ name: 'user' }"
        v-if="$store.state.token != ''"
        >{{ $store.state.user.username }}</router-link
      >

      <!-- Submit new example -->
      <router-link
        class="submit"
        v-bind:to="{ name: 'submit' }"
        v-if="$store.state.token != ''"
        >Submit</router-link
      >

      <!-- Login/Logout -->
      <router-link
        class="router-link"
        v-bind:to="{ name: 'login' }"
        v-if="$store.state.token == ''"
        >Login</router-link
      >
      <router-link
        class="router-link"
        v-bind:to="{ name: 'logout' }"
        v-if="$store.state.token != ''"
        >Logout</router-link
      >
    </div>
  </div>
</template>

<script>
export default {
  name: "navigation",
};
</script>

<style>
.main {
  display: flex;
  padding-bottom: 20px;
  justify-content: space-between;
}

#logo-image:hover {
  opacity: 0.8;
}

#not-logo {
  display: flex;
}

#logo-image {
  /* grid-area: logo; */
  width: 50%;
}

.router-link,
.submit, .userPage {
  display: flex;
  font-size: 20px;
  align-self: flex-end;
  justify-content: center;
  text-decoration: none;
  border-width: 2px;
  border-radius: 7px;
  border-style: solid;
  border-color: rgb(21, 102, 146);
  background: rgb(21, 102, 146);
  color: rgb(206, 247, 255);
  padding: 10px;
  margin-left: 20px;
}

.router-link:visited,
.submit:visited, .userPage:visited {
  color: rgb(206, 247, 255);
}

.router-link:hover,
.submit:hover, .userPage:hover {
  border-color: rgb(100, 139, 146);
  background: rgb(100, 139, 146);
  color: white;
}

.router-link:active,
.submit:active, .userPage:active {
  color: rgb(19, 168, 234);
}
</style>