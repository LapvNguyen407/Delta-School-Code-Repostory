<template>
  <div id="app">
    <div id="nav">
      <navigation />
    </div>
    <router-view :key="$route.fullPath" />
  </div>
</template>

<script>
import Navigation from "@/components/Navigation.vue";

export default {
  components: { Navigation },
};
</script>

<style>
* {
  font-family: Tahoma, Verdana, Segoe, sans-serif;
  box-sizing: border-box;
}

html {
  font-size: 16px;
  color: rgb(9, 87, 122);
  margin-left: 7%;
  margin-right: 7%;
  background-color: rgba(205, 239, 245, 0.5);
}

h2, h1 {
  font-size: 1.3rem;
  color: rgb(206, 247, 255);
  padding: 3px;
  padding-left: 10px;
  background: rgb(7, 61, 88);
  border: solid;
  border-width: 1px;

  -moz-box-shadow: 1px 2px 3px rgba(0, 0, 0, 1);
  -webkit-box-shadow: 1px 2px 3px rgba(0, 0, 0, 1);
  box-shadow: 1px 2px 3px rgba(0, 0, 0, 1);
}

h1 {
  font-size: 2.2rem;
}
</style>