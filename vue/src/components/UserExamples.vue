<template>
  <div>
    <div class="dnd">
      <h2 class="dnd-title">PRIVATE EXAMPLES</h2>
      <h2 class="dnd-title">PUBLIC EXAMPLES</h2>
    </div>

    <div class="dnd">
      <Board id="private-board">
        <Card
          v-for="example in privateExamples"
          v-bind:key="example.example_id"
          class="example-grid"
          :id="example.example_id"
          draggable="true"
        >
          <div id="lang-icon" v-on:click="routeToExample(example)">
            <img
              class="img-icon"
              v-bind:src="
                require('../../resources/' + example.language + '.png')
              "
              alt=""
            />
          </div>

          <div id="title" v-on:click="routeToExample(example)">
            {{ example.title }}
          </div>

          <div id="status" v-on:click="routeToExample(example)">
            {{ example.status }}
          </div>
          <button v-on:click="deleteExample(example.example_id)" id="btn-delete">Delete</button>
        </Card>
      </Board>

      <Board id="public-board">
        <Card
          v-for="example in publicExamples"
          v-bind:key="example.example_id"
          class="example-grid"
          :id="example.example_id"
          draggable="true"
        >
          <div id="lang-icon" v-on:click="routeToExample(example)">
            <img
              class="img-icon"
              v-bind:src="
                require('../../resources/' + example.language + '.png')
              "
              alt=""
            />
          </div>

          <div id="title" v-on:click="routeToExample(example)">
            {{ example.title }}
          </div>

          <div id="status" v-on:click="routeToExample(example)">
            {{ example.status }}
          </div>
          
          <button v-on:click="deleteExample(example.example_id)" id="btn-delete">Delete</button>
        </Card>
      </Board>
    </div>
  </div>
</template>

<script>
import exampleService from "@/services/ExamplesService";
import Board from "../components/Board.vue";
import Card from "../components/Card.vue";

export default {
  name: "user",
  props: ["example"],
  components: {
    Card,
    Board,
  },
  created() {
    this.getExamples();
  },
  methods: {
    getExamples() {
      exampleService.getUserExamples().then((response) => {
        this.$store.commit("SET_USER_EXAMPLES", response.data);
      });
    },
    routeToExample(example) {
      exampleService
        .getDefaultExamples()
        .then((response) => {
          this.$store.state.examples = response.data;
        })
        .catch((error) => console.error(error));
      console.log(example);
      if (example.status == "PUBLIC") {
        this.$router.push({
          name: "example",
          params: { id: example.example_id },
        });
      }
      if (example.status == "PRIVATE") {
        this.$router.push({
          name: "private-example",
          params: { id: example.example_id },
        });
      }
      if (example.status == "PENDING") {
        this.$router.push({
          name: "pending-example",
          params: { id: example.example_id },
        });
      }
    },
    makePublic(id) {
      exampleService.submitExampleForApproval(id).then(() => {
        this.getExamples();
      });
    },
    deleteExample(id){
      exampleService.deleteExample(id).then(() => {
        this.getExamples();
      });
    }
  },
  computed: {
    isAdmin() {
      return this.$store.state.user.authorities[0].name === "ROLE_ADMIN";
    },
    privateExamples() {
      return this.$store.state.userExamples.filter((privateList) => {
        return privateList.status === "PRIVATE";
      });
    },
    publicExamples() {
      return this.$store.state.userExamples.filter((publicList) => {
        return (
          publicList.status === "PUBLIC" || publicList.status === "PENDING"
        );
      });
    },
  },
};
</script>

<style>
#user-example-list {
  margin: 0;
  padding: 0;
}
.dnd {
  display: flex;
  justify-content: space-between;
}

.dnd-title {
  width: 49%;
  text-align: center;
}

.board {
  background: rgba(0, 0, 0, 0.3);
  width: 49%;
  height: 70vh;
  overflow-y: scroll;
}

.card {
  background: rgb(236, 236, 236);
}

.example-grid {
  display: grid;
  grid-template-columns: 60px 1fr 70px;
  grid-template-rows: 60px;
  grid-template-areas: "language title status";
  padding: 15px;
  margin: 10px;

  background: white;
  border-style: solid;
  border-width: 2px;
  border-radius: 10px;
}

.example-grid:hover {
  transform: scale(1.015);
  transition: transform 0.1s;
}

.img-icon {
  max-width: 100%;
}

#lang-icon {
  grid-area: language;
}

#title {
  grid-area: title;
  font-size: 20px;
  align-self: center;
  padding-left: 20px;
}

#status {
  grid-area: status;
  align-self: center;
}
</style>