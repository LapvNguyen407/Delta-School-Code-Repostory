<template>
  <div class="container">
    <p :id="id" class="title title-class" v-on:click="updateSelectedExample">
      <img
        class="img-icon"
        v-bind:src="require('../../resources/' + example.language + '.png')"
        alt=""
      />
      {{ example.title }}
    </p>
  </div>
</template>

<script>
import examplesService from "@/services/ExamplesService.js";
export default {
  name: "example-list-item",
  props: ["example"],
  data(){
    return{
      pageExample: this.example,
      itemLanguage: this.example.language,
    }
  },
  methods: {
      updateSelectedExample(){
          examplesService.getExampleById(this.example.example_id).then(response => {
          this.$store.commit('CREATE_SELECTED_EXAMPLE', response.data);
          this.$store.commit('SET_SELECTED_LANGUAGE', response.data.language);
          this.$router.push({ name: 'example', params: { id: this.example.example_id }})
          }
          )   
      }
  },
  mounted(){
    if(this.$route.params.id == this.id){
      let copy = document.getElementById(this.id);
      copy.classList.add('selected');
    }
  },
  computed: {
    id() {
      return this.pageExample.example_id 
    },
  }
};
</script>

<style scoped>
/* .container {
  display: flex;
} */

.title {
  padding: 5%;
  margin: 2px;
  border-width: 2px;
  border-radius: 7px;
  border-style: solid;
  border-color: rgb(21, 102, 146);
  background: rgb(16, 80, 114);
  color: rgb(0, 3, 3);
  margin-left: 5px;
}

.title:hover {
  border-color: rgb(100, 139, 146);
  background: rgb(100, 139, 146);
  color: white;
}

.selected {
  border-color: rgb(255, 0, 0);
  background: #ee6c4d;
}

.selected:hover {
  border-color: rgb(216, 80, 80);
  background: #e4a191;
}

.img-icon {
  max-width: 15px;
  background: white;
  border-radius: 5px;
}
</style>