<template>
  <div class="home">
    <h1>Select a Language to get Started</h1>

    <div class="container">
      <div
        class="languages button-container"
        v-for="language in languageArray"
        v-bind:key="language"
        v-on:click="languageSelected(language)"
      >
        <img
          class="icon button-image"
          v-bind:src="require('../../resources/' + language + '.png')"
          alt=""
        />

        <div class="label-layer button-two">
          <div class="label button-text">{{ language }}</div>
        </div>

      </div>
    </div>

  </div>
</template>

<script>
import exampleService from "@/services/ExamplesService.js";

export default {
  name: "home",
  data() {
    return {
      languageArray: [],
    };
  },
  methods: {
    languageSelected(language) {
      exampleService.getIntroId(language).then((response) => {
        this.$store.commit("SET_SELECTED_LANGUAGE", language);
        this.$router.push({ name: "example", params: { id: response.data } });
      });
    },
  },
  created() {
    exampleService.getLanguages().then((response) => {
      this.languageArray = response.data;
    });
  },
};
</script>

<style scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap;
}

.languages {
  display: flex;
  justify-content: center;
  align-items: center;
  background: white;
  border: solid;
  border-radius: 5%;
  width: 300px;
  height: 300px;
  margin: 20px;
  position: relative;
  transition: all 0.2s ease-in-out;
}

.icon {
  width: 80%;
  padding: 20px;
}

.languages:hover {
  transform: scale(1.1);
}

.label-layer {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  visibility: hidden;
  opacity: 0;
  display: flex;
  align-items: center;
  justify-content: center;

  border-width: 2px;
  border-radius: 7px;
  border-style: solid;
  border-color: rgb(13, 131, 29);
  background: rgb(21, 102, 146);
  color: rgb(206, 247, 255);

  transition: visibility 0.2s, opacity 0.2s;
}

.languages:hover .label-layer {
  visibility: visible;
  opacity: 0.7;
}

.label {
  font-size: 30px;
  opacity: 1;
}

</style>