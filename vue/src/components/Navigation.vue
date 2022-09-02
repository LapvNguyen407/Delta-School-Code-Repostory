<template>
  <div class="main">
    <!-- LOGO IMAGE -->
    <div class="glow-on-hover">
      <img
        class="logo-image"
        src="../../resources/DeltaSchoolLogo.png"
        alt="Delta School Logo"
        v-on:click="$router.push({ name: 'home' })"
      />
    </div>

    <div id="not-logo">
      <!-- User page -->
      <!-- <router-link
        class="userPage"
        v-bind:to="{ name: 'user' }"
        v-if="$store.state.token != ''"
        >{{ $store.state.user.username }}</router-link
      > -->

      <div class="arrow-container">
        <router-link
          class="log"
          id="user-name"
          v-bind:to="{ name: 'user' }"
          v-if="$store.state.token != ''"
        >
          <span class="circle" aria-hidden="true">
            <span class="icon arrow"> </span>
          </span>
          <span class="button-text">{{ $store.state.user.username }}</span>
        </router-link>
      </div>

      <!-- Submit new example -->
      <!-- <router-link
        class="submit"
        v-bind:to="{ name: 'submit' }"
        v-if="$store.state.token != ''"
      >
        <span data-attr="Add">Add</span
        ><span data-attr="Example">Example</span></router-link
      > -->

      <div class="arrow-container">
        <router-link
          class="log"
          id="add-example"
          v-bind:to="{ name: 'submit' }"
          v-if="$store.state.token != ''"
        >
          <span class="circle" aria-hidden="true">
            <span class="icon arrow"></span>
          </span>
          <span class="button-text">Add Example</span></router-link
        >
      </div>

      <!-- Login/Logout -->
      <div class="arrow-container">
        <router-link
          class="log"
          id="login-logout"
          v-bind:to="{ name: 'login' }"
          v-if="$store.state.token == ''"
        >
          <span class="circle" aria-hidden="true">
            <span class="icon arrow"></span>
          </span>

          <span class="button-text">Login</span></router-link
        >
        <router-link
          class="log"
          id="login-logout"
          v-bind:to="{ name: 'logout' }"
          v-if="$store.state.token != ''"
        >
          <span class="circle" aria-hidden="true">
            <span class="icon arrow"></span>
          </span>

          <span class="button-text">Logout</span></router-link
        >
      </div>
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
  background: rgb(229, 246, 249);
}

.glow-on-hover {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  width: 50%;
  border: none;
  outline: none;
  cursor: pointer;
  position: relative;
  z-index: 0;
}

.logo-image {
  width: 98%;
  /* BACKGROUND FOR BORDER GLOW EFFECT */
  padding-top: 5px;
  padding-bottom: 5px;
  padding-right: 5px;
  padding-left: 5px;
  background: rgb(229, 246, 249);
  border-radius: 15px;
}

.glow-on-hover:before {
  content: "";
  background: linear-gradient(
    45deg,
    rgb(129, 228, 243),
    rgb(95, 181, 228),
    rgb(65, 163, 216),
    rgb(36, 150, 211),
    rgb(16, 135, 199),
    rgb(36, 150, 211),
    rgb(65, 163, 216),
    rgb(95, 181, 228),
    rgb(129, 228, 243)
  );
  position: absolute;
  top: -2px;
  left: -2px;
  background-size: 400%;
  z-index: -1;
  filter: blur(5px);
  width: calc(100% + 4px);
  height: calc(100% + 4px);
  animation: glowing 20s linear infinite;
  opacity: 0;
  transition: opacity 0.3s ease-in-out;
  border-radius: 15px;
}

.glow-on-hover:active {
  background: rgb(229, 246, 249);
}

.glow-on-hover:active:after {
  background: transparent;
}

.glow-on-hover:hover:before {
  opacity: 0.7;
}

.glow-on-hover:after {
  z-index: -1;
  content: "";
  widows: 100%;
  height: 100%;
  position: absolute;
  background: rgb(229, 246, 249);
  left: 0;
  top: 0;
  border-radius: 15px;
}

@keyframes glowing {
  0% {
    background-position: 0 0;
  }
  50% {
    background-position: 400% 0;
  }
  100% {
    background-position: 0 0;
  }
}

#not-logo {
  display: flex;
  align-self: flex-end;
}

.userPage {
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

  -moz-box-shadow: 2px 4px 6px rgba(0, 0, 0, 0.5);
  -webkit-box-shadow: 2px 4px 6px rgba(0, 0, 0, 0.5);
  box-shadow: 2px 4px 6px rgba(0, 0, 0, 0.5);
}

/* <======================================================================================> */
/* <=============================== {{{Box Flip}}} STYLES ================================> */
/* <======================================================================================> */

.submit {
  font-size: 20px;
  font-weight: bold;
  margin: 10px;

  -moz-box-shadow: 2px 4px 6px rgba(0, 0, 0, 0.5);
  -webkit-box-shadow: 2px 4px 6px rgba(0, 0, 0, 0.5);
  box-shadow: 2px 4px 6px rgba(0, 0, 0, 0.5);
}

.submit span {
  transition: 0.5s;
  padding: 10px;
  position: relative;
  text-transform: uppercase;
}

.submit span:nth-child(1) {
  color: rgb(206, 247, 255);
  background: rgb(21, 102, 146);
}

.submit span:nth-child(2) {
  color: rgb(206, 247, 255);
  background: rgb(19, 168, 234);
}

.submit span:nth-child(1):before {
  content: attr(data-attr);
  position: absolute;
  top: 0;
  left: 0;
  background: rgb(19, 168, 234);
  padding: 10px;
  transition: 0.5s;
  transform-origin: top;
  transform: rotateX(90deg) translateY(-50%);
}

.submit:hover span:nth-child(1):before {
  transform: rotateX(0deg) translateY(0%);
}

.submit span:nth-child(2):before {
  content: attr(data-attr);
  position: absolute;
  top: 0;
  left: 0;
  background: rgb(21, 102, 146);
  padding: 10px;
  transition: 0.5s;
  transform-origin: bottom;
  transform: rotateX(90deg) translateY(50%);
}

.submit:hover span:nth-child(2):before {
  transform: rotateX(0deg) translateY(0%);
}

.submit span:nth-child(1):after {
  content: attr(data-attr);
  padding: 10px;
  position: absolute;
  top: 0;
  left: 0;
  background: rgb(21, 102, 146);
  transform-origin: bottom;
  transform: rotateX(0deg) translateY(0%);
  transition: 0.5s;
}
.submit:hover span:nth-child(1):after {
  transform: rotateX(90deg) translateY(50%);
}
.submit span:nth-child(2):after {
  content: attr(data-attr);
  position: absolute;
  top: 0;
  left: 0;
  background: rgb(19, 168, 234);
  padding: 10px;
  transition: 0.5s;
  transform-origin: top;
  transform: rotateX(0deg) translateY(0%);
}
a:hover span:nth-child(2):after {
  transform: rotateX(90deg) translateY(-50%);
}

/* <=========================================================================================> */
/* <============================ [[[ARROW PUSH BUTTON]]] STYLES =============================> */
/* <=========================================================================================> */

.arrow-container {
  box-sizing: border-box;
  display: flex;
  font-size: 20px;
  font-weight: bold;
  line-height: 1.5;
  align-items: center;
  justify-items: center;
}

.log {
  position: relative;
  display: inline-block;
  cursor: pointer;
  outline: none;
  border: 0;
  vertical-align: middle;
  text-decoration: none;
  background: transparent;
  padding: 0;
  height: auto;
}

#user-name {
  width: 11rem;
}

#add-example {
  width: 15rem;
}

#login-logout {
  width: 12rem;
}

.log .circle {
  transition: all 0.45s cubic-bezier(0.65, 0, 0.076, 1);
  position: relative;
  display: block;
  margin: 0;
  width: 3rem;
  height: 3rem;
  background: rgb(21, 102, 146);
  border-radius: 1.625rem;
}

.log .circle .icon {
  transition: all 0.45s cubic-bezier(0.65, 0, 0.076, 1);
  position: absolute;
  top: 0;
  bottom: 0;
  margin: auto;
  background: rgb(206, 247, 255);
}

.log .circle .icon.arrow {
  transition: all 0.45s cubic-bezier(0.65, 0, 0.076, 1);
  left: 0.625rem;
  width: 1.125rem;
  height: 0.125rem;
  background: none;
}

.log .circle .icon.arrow::before {
  position: absolute;
  content: "";
  top: -0.25rem;
  right: 0.0625rem;
  width: 0.625rem;
  height: 0.625rem;
  border-top: 0.125rem solid rgb(206, 247, 255);
  border-right: 0.125rem solid rgb(206, 247, 255);
  transform: rotate(45deg);
}

.log .button-text {
  transition: all 0.45s cubic-bezier(0.65, 0, 0.076, 1);
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 0.6rem 0;
  margin: 0 0 0 1.85rem;
  color: rgb(21, 102, 146);
  font-weight: 700;
  line-height: 1.6;
  text-align: center;
  text-transform: uppercase;
}

.log:hover .circle {
  width: 100%;
}

.log:hover .circle .icon.arrow {
  background: rgb(206, 247, 255);
  transform: translate(1rem, 0);
}

.log:hover .button-text {
  color: rgb(206, 247, 255);
}
</style>