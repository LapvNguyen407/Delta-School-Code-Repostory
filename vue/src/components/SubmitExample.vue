<template>
  <div>
    <h1 class="submit-notice" v-show="submitted">
      Your example has been submitted for review
    </h1>

    <form class="submit-form-flex">
      <h2>
        <label for="title">Title:</label>
      </h2>

      <div>
        <input type="text" id="title" v-model="fields.title" />
      </div>

      <h2>
        <label for="language">Language:</label>
      </h2>

      <div class="holder">
        <div
          class="button"
          v-for="language in languages"
          :key="language"
          v-bind:class="{ selected: language == fields.language }"
          v-on:click="toggleLanguage(language)"
        >
          <div>
            <div class="btnText">
              <img
                class="picture button-image"
                v-bind:src="require('../../resources/' + language + '.png')"
                alt=""
              />
            </div>
          </div>

          <div class="btnTwo">
            <div class="btnText2">{{ language }}</div>
          </div>
        </div>
      </div>

      <h2>
        <label for="description">Description:</label>
      </h2>

      <div>
        <input type="file" @change="Images_onFileChanged" />
      </div>

      <div>
        <textarea
          name="description"
          id="description"
          cols="30"
          rows="10"
          v-model="fields.description"
        ></textarea>
      </div>

      <h2>
        <label for="code">Code:</label>
      </h2>

      <div>
        <textarea
          name="code"
          id="code"
          cols="30"
          rows="10"
          v-model="fields.code"
        ></textarea>
      </div>

      <h2>Tags:</h2>

      <div id="tag-container">
        <div
          id="tag-view"
          v-for="tag in tags"
          :key="tag"
          :class="{tagSelected: selectedTags.includes(tag)}"
          v-on:click.prevent="filterTag(tag)"
        >
          <label :for="tag">{{ tag }}</label>
          <input
            v-show="false"
            type="checkbox"
            :checked="selectedTags.includes(tag)"
            :id="tag"
          />
        </div>
      </div>

      <h2>
        <label for="attribution">Attribution:</label>
      </h2>
      <div>
        <input type="text" id="attribution" v-model="fields.attribution" />
      </div>

      <!-- SUBMIT BUTTON -->
      <input
        id="btn-submit"
        type="submit"
        :disabled="isDisabled"
        v-on:click.prevent="addPendingExample"
      />
    </form>
  </div>
</template>

<script>
import examplesService from "@/services/ExamplesService";
import { getStorage, ref, uploadBytes, getDownloadURL } from "firebase/storage";
export default {
  name: "submit",

  data() {
    return {
      languages: [],
      tags: [],
      selectedTags: [],
      submitted: false,
      fields: {
        title: "",
        language: "",
        description: "",
        code: "",
        attribution: "",
      },
      selectedFile: null,
      imageURL: null,
    };
  },
  methods: {
    addPendingExample() {
      const newExample = {
        title: this.fields.title,
        language: this.fields.language,
        description: this.fields.description,
        code: this.fields.code,
        attribution: this.fields.attribution,
        tags: this.selectedTags,
      };
      examplesService.addPrivateExample(newExample).then((response) => {
        if (response.status === 201) {
          this.uploadImage(this.selectedFile, response.data.example_id);
        }
      });
      this.selectedTags = [];
      this.fields = {
        title: "",
        language: "",
        description: "",
        code: "",
        attribution: "",
      };
    },
    filterTag(tag) {
      const index = this.selectedTags.indexOf(tag);
      if (index > -1) {
        this.selectedTags.splice(index, 1);
      } else {
        this.selectedTags.unshift(tag);
      }
    },
    scrollToTop() {
      window.scrollTo(0, 0);
    },
    Images_onFileChanged(event) {
      this.selectedFile = event.target.files[0];
    },
    uploadImage(file, id) {
      let fileName = "example" + id;
      const storage = getStorage();
      const storageRef = ref(storage, fileName);

      // 'file' comes from the Blob or File API
      uploadBytes(storageRef, file).then(() => {
        getDownloadURL(storageRef).then((downloadURL) => {
          console.log("File available at", downloadURL);
          examplesService.appendImageLink(id, downloadURL);
          this.submitted = true;
          this.scrollToTop();
        });
      });
    },
    toggleLanguage(language) {
      this.fields.language = language;
    },
  },

  computed: {
    isDisabled() {
      for (const value in this.fields) {
        if (this.fields[value] == "") {
          return true;
        }
      }
      if (this.selectedTags.length == 0) {
        return true;
      }
      return false;
    },
  },

  created() {
    examplesService.getLanguages().then((response) => {
      this.languages = response.data;
    });
    examplesService.getTags().then((response) => {
      this.tags = response.data;

      //Hide default as a tag since a user shouldn't be accessing that tag here
      const index = this.tags.indexOf("default");
      this.tags.splice(index, 1);
    });
  },
};
</script>

<style>
#title {
  width: 100%;
}
#code {
  height: 200px;
  width: 100%;
}
#description {
  height: 100px;
  width: 100%;
}
#attribution {
  width: 25%;
}
#btn-submit {
  width: 15%;
}

#tag-view:nth-child(odd) {
  background: rgb(173, 243, 243);
}

#tag-view:hover {
  background: rgb(13, 167, 167);
}

.submit-form-flex {
  display: flex;
  justify-content: center;
  align-items: stretch;
}

.submit-notice {
  background: rgb(24, 105, 35);
  color: whitesmoke;
}

/* <======================================================================================> */
/* <================================= [[[TAGS]]] STYLES ==================================> */
/* <======================================================================================> */

#tag-container {
  display: flex;
  flex-direction: row;
  padding: 5px;
  margin: 0px;
  padding: 5px;
  margin: 0px;
  justify-content: space-evenly;
}

#tag-view {
  flex: stretch;
  list-style: none;
  padding: 15px;
  margin: 5px;
  font-size: 15px;
  text-transform: uppercase;
  border-radius: 7px;

  border-width: 2px;
  border-style: solid;
  border-color: rgb(8, 134, 202);
  background: rgb(120, 247, 247);
}

#tag-view:hover {
  /* li:hover { */
  background: rgb(115, 172, 172);
}

.tagSelected {
  border-color: rgb(255, 0, 0) !important;
  background: #ee6c4d !important;
}

.tagSelected:hover {
  border-color: rgb(216, 80, 80) !important;
  background: #e4a191 !important;
}

/* <======================================================================================> */
/* <=============================== {{{Box Push}}} STYLES ================================> */
/* <======================================================================================> */

.holder {
  display: flex;
  justify-content: space-between;
}

.picture {
  margin: 2px;
  padding-top: 2px;
  padding-bottom: 2px;
  height: 46px;
  background: white;
  border-radius: 5px;
}

.button {
  background: #979da0;
  margin: 20px auto;
  width: 200px;
  height: 50px;
  overflow: hidden;
  text-align: center;
  transition: 0.2s;
  cursor: pointer;
  border-radius: 5px;
  box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.2);
}

.selected {
  background: rgb(13, 90, 153);
  transition: 0.8s;
}

.btnTwo {
  position: relative;
  text-align: center;
  width: 200px;
  height: 100px;
  margin-top: -100px;
  padding-top: 2px;
  background: #26a69a;
  left: -250px;
  transition: 0.3s;
}

.btnText {
  transition: 0.3s;
}

.btnText2 {
  margin-top: 63px;
  margin-right: -130px;
  color: #fff;
}

.button:hover .btnTwo {
  /*When hovering over .button change .btnTwo*/
  left: -80px;
}

.button:hover .btnText {
  /*When hovering over .button change .btnText*/
  margin-left: 120px;
}

.button:hover .btnText2 {
  /*When hovering over .button change .btnText*/
  margin-left: -50px;
}

.button:active {
  /*Clicked and held*/
  box-shadow: 0px 5px 6px rgba(0, 0, 0, 0.3);
}
</style>