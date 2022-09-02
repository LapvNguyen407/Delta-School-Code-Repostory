<template>
  <div id="admin-examples">
    <div>
      <button v-if="isAdmin" v-on:click="switchView('All')">VIEW ALL</button>
      <button v-if="isAdmin" v-on:click="switchView('Pending')">
        VIEW PENDING
      </button>
      <button v-if="isAdmin" v-on:click="switchView('Admin')">
        VIEW YOUR OWN
      </button>
      <button v-if="isAdmin" v-on:click="switchView('Default')">
        VIEW DEFAULT
      </button>
    </div>
    
    <div v-if="pageExamples.length == 0 && examplesToView != 'Pending'">
      <h2>This page displays your examples. Submit an example to get started!</h2>
    </div>
    <div v-if="pageExamples.length == 0 && examplesToView == 'Pending'">
      <h2>There are no pending examples!</h2>
    </div>

    <!-- EXAMPLES -->
    <ul>
      <div
        v-for="example in pageExamples"
        v-bind:key="example.example_id"
        class="example-grid"
      >
        <div
          id="lang-icon"
          v-on:click="routeToExample(example)"
        >
          <img
            class="img-icon"
            v-bind:src="require('../../resources/' + example.language + '.png')"
            alt=""
          />
        </div>
        <div
          id="title"
          v-on:click="routeToExample(example)"
        >
          {{ example.title }}
        </div>
        <div
          id="status"
          v-on:click="routeToExample(example)"
        >
          {{ example.status }}
        </div>
        <div id="btn-flex">
          <button
            id="btn-public"
            v-show="example.status == 'PRIVATE'"
            v-on:click="makePublic(example.example_id)"
          >
            Make Public
          </button>
          
          <button
            id="btn-approve"
            v-if="isAdmin"
            v-show="example.status == 'PENDING'"
            v-on:click="approvePendingExample(example.example_id)"
          >
            Approve
          </button>
          <button
            id="btn-reject"
            v-if="isAdmin"
            v-show="example.status == 'PENDING'"
            v-on:click="declinePendingExample(example.example_id)"
          >
            Reject
          </button>
          <button
            id="btn-reject"
            v-if="isAdmin"
            v-show="
              !example.tags.includes('default') && example.status == 'PUBLIC'
            "
            v-on:click="makeDefault(example.example_id)"
          >
            Make Default
          </button>
          <button
            id="btn-reject"
            v-if="isAdmin"
            v-show="example.tags.includes('default')"
            v-on:click="removeDefault(example.example_id)"
          >
            Remove Default
          </button>
        </div>
      </div>
    </ul>
  </div>
</template>

<script>
import exampleService from "@/services/ExamplesService";
import emailService from "@/services/EmailService"
export default {
  name: "admin",
  props: ["example"],
  data() {
    return {
      pageExamples: [],
      examplesToView: "Admin",
    };
  },
  created() {
    this.getExamples();
  },
  methods: {
    getExamples() {
      if (this.examplesToView === "Admin") {
        exampleService.getUserExamples().then((response) => {
          this.pageExamples = response.data;
        });
      } else if (this.examplesToView === "Pending") {
        exampleService.getPendingExamples().then((response) => {
          this.pageExamples = response.data;
        });
      } else if (this.examplesToView === "Default") {
        exampleService.getDefaultExamples().then((response) => {
          this.pageExamples = response.data;
        });
      } else if (this.examplesToView === "All") {
        exampleService.getAllExamples().then((response) => {
          this.pageExamples = response.data;
        });
      }
    },
    switchView(newView) {
      this.examplesToView = newView;
      this.getExamples();
    },
    routeToExample(example) {
      exampleService
      .getDefaultExamples()
      .then((response) => {
        this.$store.state.examples = response.data;
      })
      .catch((error) => console.error(error));
      if (example.status == "PUBLIC") {
        this.$store.commit("CREATE_SELECTED_EXAMPLE", example);
        this.$router.push({ name: "example", params: { id: example.example_id } });
      }
      if (example.status == "PRIVATE") {
        this.$store.commit("CREATE_SELECTED_EXAMPLE", example);
        this.$router.push({ name: "private-example", params: { id: example.example_id } });
      }
      if (example.status == "PENDING") {
        this.$store.commit("CREATE_SELECTED_EXAMPLE", example);
        this.$router.push({ name: "pending-example", params: { id: example.example_id } });
      }
    },
    makePublic(id) {
      exampleService.submitExampleForApproval(id).then(() => {
        this.getExamples();
      });
    },
    approvePendingExample(id) {
      exampleService.approvePendingExample(id).then(() => {
        exampleService.getExampleById(id).then((response) => {
            emailService.sendEmailsToSubscribers(response.data)
        })
        this.getExamples();
      });
    },
    declinePendingExample(id) {
      exampleService.declinePendingExample(id).then(() => {
        this.getExamples();
      });
    },
    makeDefault(id) {
      exampleService.makeDefault(id).then(() => {
        this.getExamples();
      });
    },
    removeDefault(id) {
      exampleService.removeDefault(id).then(() => {
        this.getExamples();
      });
    },
  },
  computed: {
    isAdmin() {
      return this.$store.state.user.authorities[0].name === "ROLE_ADMIN";
    },
  },
};
</script>

<style scoped>
#admin-examples {
  overflow-y: scroll;
  overflow-x: hidden;
  /* Hide scrollbar for IE, Edge and Firefox */
  -ms-overflow-style: none; /* IE and Edge */
  scrollbar-width: none; /* Firefox */
  height: 80vh;
}

/* Hide scrollbar for Chrome, Safari and Opera */
#admin-examples::-webkit-scrollbar {
  display: none;
}

.example-grid {
  display: grid;
  grid-template-columns: 60px 1fr 10% 160px;
  grid-template-rows: 60px;
  grid-template-areas: "language title status buttons";
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