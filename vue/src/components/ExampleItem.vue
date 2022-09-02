<template>
  <div>
    <div
      v-if="
        this.$store.state.selectedExample == '' ||
        this.$store.state.selectedExample.example_id == 0
      "
    >
      <h1>Welcome to DeltaSchools!</h1>
      <p>Select a code example from the right to get started!</p>
    </div>

    <!-- Example Display Elements -->
    <div
      v-if="
        this.$store.state.selectedExample != '' &&
        this.$store.state.selectedExample.example_id != 0
      "
    >
      <!-- Titles and Headers -->
      <h1>{{ this.$store.state.selectedExample.language }}</h1>
      <h2>{{ this.$store.state.selectedExample.title }}</h2>

      <!-- Description -->
      <p v-if="!this.$store.state.selectedExample.imageUrl">
        {{ this.$store.state.selectedExample.description }}
      </p>

      <div
        class="description"
        v-if="this.$store.state.selectedExample.imageUrl"
      >
        <p id="user-description">
          {{ this.$store.state.selectedExample.description }}
        </p>

        <img
          id="user-image"
          :src="this.$store.state.selectedExample.imageUrl"
        />
      </div>

      <!-- Codeblock -->
      <blockquote v-show="this.$store.state.selectedExample.code.length > 0">
        <code id="code" class="prettyprint" v-html="selectedCodeExample"
          >{{ selectedCodeExample }}
        </code>
      </blockquote>
      <div id="subscription">
        <div id="submitter">
          <h3>submitted by: {{ submittedBy }}</h3>
        </div>
        <div id="subscribe-btn" v-on:click="updateSubscription">
          <h3>{{ subUnsub }}</h3>
        </div>
      </div>

      <!-- Compiler -->
      <div v-show="isCompiled">
        <h2>Code output:</h2>
        <p id="APIResponse">{{ APIResponse }}</p>
      </div>

      <!-- ================= BUTTONS ================= -->

      <div id="bttn-flex">
        <!-- Copy to Clipboard -->
        <div class="center">
          <div
            class="href"
            v-on:click.prevent="copyCode"
            v-show="this.$store.state.selectedExample.code.length > 0"
          >
            <span data-attr="Copy to">Copy to</span
            ><span data-attr="Clipboard">Clipboard</span>
          </div>
        </div>

        <!-- Run this Code -->
        <div class="center">
          <div class="href" v-on:click.prevent="runCode" v-show="isRunnable">
            <span data-attr="Run this">Run this</span
            ><span data-attr="Code >>">Code >></span>
          </div>
        </div>

        <div class="center">
          <div
            class="href"
            v-show="!showForm && $store.state.token != ''"
            v-on:click.prevent="showForm = !showForm"
          >
            <span data-attr="Update">update</span
            ><span data-attr="attribution">attribution</span>
          </div>
        </div>

        <!-- Update Attribution -->
        <div v-show="updateStatus == 'unauthorized'" class="error">
          You must be logged in to update attribution!
        </div>
        <div v-show="updateStatus == 'textError'" class="error">
          That attribution was too long!
        </div>

        <form v-show="showForm" v-on:submit.prevent="updateAttribution">
          <input class="attr-input" type="text" v-model="newAttribution" />
          <div class="center">
            <div class="href">
              <span data-attr="Update">update</span
              ><span data-attr="attribution">attribution</span>
            </div>
          </div>
        </form>
      </div>

      <!-- Attribution -->
      <div id="attr-flex">
        <p>{{ this.$store.state.selectedExample.attribution }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import examplesService from "@/services/ExamplesService.js";
import emailService from "@/services/EmailService.js";
export default {
  name: "example-item",
  data() {
    return {
      showForm: false,
      newAttribution: "",
      updateStatus: "unsent",
      isCompiled: false,
      APIResponse: "",
      submittedBy: "",
    };
  },
  computed: {
    selectedCodeExample() {
      let code = window.PR.prettyPrintOne(
        this.$store.state.selectedExample.code
      );
      return code;
    },
    isRunnable() {
      if (this.$store.state.selectedExample.code.length == 0) {
        return false;
      }
      if (this.$store.state.selectedExample.language == "CSS") {
        return false;
      }
      if (this.$store.state.selectedExample.language == "SQL") {
        return false;
      }
      return true;
    },
    subUnsub() {
      if (this.$store.state.subscriptions.includes(this.submittedBy)) {
        return " Unsubscribe ";
      } else {
        return " Subscribe ";
      }
    },
  },

  created() {
    this.showForm = false;
    (this.newAttribution = ""), (this.updateStatus = "unsent");
    this.getData();
  },
  mounted() {},
  methods: {
    updateAttribution() {
      let updatedExample = {
        example_id: this.$store.state.selectedExample.example_id,
        title: this.$store.state.selectedExample.title,
        language: this.$store.state.selectedExample.language,
        description: this.$store.state.selectedExample.description,
        code: this.$store.state.selectedExample.code,
        userId: this.$store.state.selectedExample.userId,
        attribution: this.newAttribution,
      };

      examplesService
        .updateAttribution(updatedExample)
        .then((response) => {
          if (response.status == 200) {
            this.$store.commit(
              "CREATE_SELECTED_EXAMPLE",
              response.data
            );
            this.getData();
            this.updateStatus = "sent";
          }
        })
        .catch((error) => {
          if (error.response.status == 401) {
            this.updateStatus = "unauthorized";
          } else if (error.response.status == 500) {
            this.updateStatus = "textError";
          }
        });
      this.showForm = false;
    },
    getData() {
      if (this.$route.name == "private-example") {
        examplesService
          .getPrivateExampleById(Number(this.$route.params.id))
          .then((response) => {
            this.$store.commit("CREATE_SELECTED_EXAMPLE", response.data);
            this.getUsername(this.$store.state.selectedExample.userId);
          });
      } else if (this.$route.name == "example") {
        examplesService
          .getExampleById(Number(this.$route.params.id))
          .then((response) => {
            this.$store.commit("CREATE_SELECTED_EXAMPLE", response.data);
            this.getUsername(this.$store.state.selectedExample.userId);
          });
      } else if (this.$route.name == "pending-example") {
        examplesService
          .getPendingExampleById(Number(this.$route.params.id))
          .then((response) => {
            this.$store.commit("CREATE_SELECTED_EXAMPLE", response.data);
            this.getUsername(this.$store.state.selectedExample.userId);
          });
      }
    },
    getUsername(userId) {
      emailService.getUsername(userId).then((response) => {
        this.submittedBy = response.data;
      });
    },
    updateSubscription() {
      if (this.$store.state.subscriptions.includes(this.submittedBy)) {
        emailService.unsubscribe(this.$store.state.selectedExample.userId)
        .then(response => {
          this.$store.commit('SET_SUBSCRIBERS', response.data)
        });
      } else {
        emailService.subscribe(this.$store.state.selectedExample.userId)
        .then(response => {
          this.$store.commit('SET_SUBSCRIBERS', response.data)
        });
      }
    },
    copyCode() {
      /* Get the text field */
      let copy = document.getElementById("code");
      let copyText = copy.textContent;

      /* Copy the text inside the text field */
      navigator.clipboard.writeText(copyText);
    },
    runCode() {
      const requestData = {
        clientId: "0",
        clientSecret: "0",
        script: this.$store.state.selectedExample.code,
        language: "",
        versionIndex: "0",
      };
      if (this.$store.state.selectedExample.language.toLowerCase() == "java") {
        requestData.language = "java";
      } else if (
        this.$store.state.selectedExample.language.toLowerCase() == "javascript"
      ) {
        requestData.language = "nodejs";
      }
      examplesService.compileCode(requestData).then((response) => {
        this.APIResponse = response.data;
        this.isCompiled = true;
      });
    },
  },
};
</script>

<style>
code {
  display: block;
  white-space: pre;
  -webkit-overflow-scrolling: touch;
  overflow-x: auto;
  max-width: 100%;
  min-width: 100px;
  padding: 20px;
}

.error {
  color: red;
}

button {
  font-size: 15px;
  border-color: rgb(21, 102, 146);
  background: rgb(1, 10, 15);
  color: rgb(206, 247, 255);
}

button:hover {
  border-color: rgb(100, 139, 146);
  background: rgb(100, 139, 146);
  color: white;
}

#APIResponse {
  background-color: #172633;
  color: white;
  padding: 10px;
  font-size: 15px;
  width: 100%;
  white-space: pre-wrap;
}

#bttn-flex {
  display: flex;
  justify-content: space-between;
}

#attr-flex {
  display: flex;
  justify-content: flex-end;
}

.attr-input {
  margin-bottom: 15px;
}

.description {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-template-areas: "desc img";
}

#user-description {
  grid-area: desc;
}

#user-img {
  grid-area: img;
}

/* <======================================================================================> */
/* <=============================== {{{Box Flip}}} STYLES ================================> */
/* <======================================================================================> */

.center {
  font-size: 15px;
  font-weight: bold;
  margin: 5px;
}

.href span {
  transition: 0.5s;
  padding: 10px;
  position: relative;
  text-transform: uppercase;
}

.href span:nth-child(1) {
  color: rgb(206, 247, 255);
  background: rgb(21, 102, 146);
}

.href span:nth-child(2) {
  color: rgb(206, 247, 255);
  background: rgb(19, 168, 234);
}

.href span:nth-child(1):before {
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

.href:hover span:nth-child(1):before {
  transform: rotateX(0deg) translateY(0%);
}

.href span:nth-child(2):before {
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

.href:hover span:nth-child(2):before {
  transform: rotateX(0deg) translateY(0%);
}

.href span:nth-child(1):after {
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
.href:hover span:nth-child(1):after {
  transform: rotateX(90deg) translateY(50%);
}
.href span:nth-child(2):after {
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
.href:hover span:nth-child(2):after {
  transform: rotateX(90deg) translateY(-50%);
}

.center:active {
  transition: 0.15s;
  box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.8);
}

/* SUBSCRIPTION DIV AND CHILDREN GRID */

#subscription {
  display: grid;
  grid-template-columns: 1fr 1fr 7fr;
  grid-template-areas: "submitter subscribe . ";
}
#submitter {
  display: inline;
  grid-area: submitter;
}
#submitter h3{
  display: inline;
}
#subscribe-btn {
  display: inline;
  grid-area: subscribe;
  color: rgb(206, 10, 10);
}
#subscribe-btn h3 {
  display: inline-block;
  border-style: solid;
  border-color: rgb(206, 10, 10);
  border-width: 2px;
  border-radius: 5px;
  transition: 0.3s;
  margin-left: 10px;
}

#subscribe-btn h3:hover {
  color: white;
  background: rgb(206,10,10);
}

/* Pretty printing styles. Used with prettify.js. */
/* Vim sunburst theme by David Leibovic */

pre .str,
code .str {
  color: #65b042;
} /* string  - green */
pre .kwd,
code .kwd {
  color: #e28964;
} /* keyword - dark pink */
pre .com,
code .com {
  color: #aeaeae;
  font-style: italic;
} /* comment - gray */
pre .typ,
code .typ {
  color: #89bdff;
} /* type - light blue */
pre .lit,
code .lit {
  color: #3387cc;
} /* literal - blue */
pre .pun,
code .pun {
  color: #fff;
} /* punctuation - white */
pre .pln,
code .pln {
  color: #fff;
} /* plaintext - white */
pre .tag,
code .tag {
  color: #89bdff;
} /* html/xml tag    - light blue */
pre .atn,
code .atn {
  color: #bdb76b;
} /* html/xml attribute name  - khaki */
pre .atv,
code .atv {
  color: #65b042;
} /* html/xml attribute value - green */
pre .dec,
code .dec {
  color: #3387cc;
} /* decimal - blue */

pre.prettyprint,
code.prettyprint {
  background-color: #000;
  border-radius: 8px;
}

pre.prettyprint {
  width: 95%;
  margin: 1em auto;
  padding: 1em;
  white-space: pre-wrap;
}

/* Specify class=linenums on a pre to get line numbering */
ol.linenums {
  margin-top: 0;
  margin-bottom: 0;
  color: #aeaeae;
} /* IE indents via margin-left */
li.L0,
li.L1,
li.L2,
li.L3,
li.L5,
li.L6,
li.L7,
li.L8 {
  list-style-type: none;
}
/* Alternate shading for lines */

@media print {
  pre .str,
  code .str {
    color: #060;
  }
  pre .kwd,
  code .kwd {
    color: #006;
    font-weight: bold;
  }
  pre .com,
  code .com {
    color: #600;
    font-style: italic;
  }
  pre .typ,
  code .typ {
    color: #404;
    font-weight: bold;
  }
  pre .lit,
  code .lit {
    color: #044;
  }
  pre .pun,
  code .pun {
    color: #440;
  }
  pre .pln,
  code .pln {
    color: #000;
  }
  pre .tag,
  code .tag {
    color: #006;
    font-weight: bold;
  }
  pre .atn,
  code .atn {
    color: #404;
  }
  pre .atv,
  code .atv {
    color: #060;
  }
}
</style>