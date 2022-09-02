<template>
  <form>
    <h2>Search</h2>

    <div>
      <input type="text" v-model="filterData.titleFilter" />
    </div>

    <div class="container">
      <div
        class="languages"
        v-for="language in languages"
        v-bind:key="language"
        v-bind:class="{ selected: language == filterData.languageFilter }"
        v-on:click="toggleLanguage(language)"
      >
        <img
          class="img-icon"
          v-bind:src="require('../../resources/' + language + '.png')"
          alt=""
        />

        <div class="label-layer">
          <div class="label">
            {{ language }}
          </div>
        </div>
      </div>
    </div>

    <h2>
      Select Tags
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="16"
        height="16"
        fill="currentColor"
        class="bi bi-tag-fill"
        viewBox="0 0 16 16"
      >
        <path
          d="M2 1a1 1 0 0 0-1 1v4.586a1 1 0 0 0 .293.707l7 7a1 1 0 0 0 1.414 0l4.586-4.586a1 1 0 0 0 0-1.414l-7-7A1 1 0 0 0 6.586 1H2zm4 3.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"
        />
      </svg>
    </h2>

    <ul id="list-container">
      <li
        id="list-view"
        v-for="tag in tags"
        v-bind:key="tag"
        v-on:click="filterTag(tag)"
        v-bind:class="{ tagSelected: filterData.tagsFilter.includes(tag) }"
      >
        <div v-bind:id="tag">
          {{ tag }}
        </div>
      </li>
    </ul>

    <button v-on:click.prevent="toggleSelectAll">
      {{ selectDeselectAll }}
    </button>
  </form>
</template>

<script>
import ExamplesService from "@/services/ExamplesService";

export default {
  name: "search-tab",
  data() {
    return {
      filterData: {
        titleFilter: "",
        languageFilter: "",
        tagsFilter: [],
      },
      languages: [],
      tags: [],
      isSelected: false,
    };
  },
  created() {
    ExamplesService.getLanguages().then((response) => {
      this.languages = response.data;
      this.languages.unshift("All");
      this.filterData.languageFilter =
        this.$store.state.selectedExample.language;
    });
    ExamplesService.getTags().then((response) => {
      this.tags = response.data;

      //Hide default as a tag since a user shouldn't be accessing that tag here
      const index = this.tags.indexOf("default");
      this.tags.splice(index, 1);
    });
    this.updateFilters();
  },
  computed: {
    selectDeselectAll() {
      if (this.filterData.tagsFilter.length > 0) {
        return "Deselect All";
      } else {
        return "Select All";
      }
    },
  },
  methods: {
    setLanguage() {
      this.filterData.languageFilter =
        this.$store.state.selectedExample.language;
    },
    filterTag(tag) {
      const index = this.filterData.tagsFilter.indexOf(tag);
      if (index > -1) {
        this.filterData.tagsFilter.splice(index, 1);
      } else {
        this.filterData.tagsFilter.unshift(tag);
      }
      this.updateFilters();
    },
    updateFilters() {
      this.$store.commit("SET_FILTER_DATA", this.filterData);
    },
    toggleLanguage(language) {
      this.filterData.languageFilter = language;
      this.updateFilters();
    },

    toggleSelectAll() {
      if (this.filterData.tagsFilter.length > 0) {
        this.filterData.tagsFilter = [];
      } else {
        this.tags.forEach((tag) => {
          this.filterData.tagsFilter.push(tag);
        });
      }
    },
  },
};
</script>

<style scoped>
#list-container {
  /* ul { */
  display: flex;
  flex-direction: column;
  padding: 5px;
  margin: 0px;
}

#list-view {
  /* li { */
  list-style: none;
  padding: 5px;
  margin: 1px;
  font-size: 15px;
  text-transform: uppercase;
  border-radius: 7px;
  border-width: 2px;
  border-style: solid;
  border-color: rgb(80, 120, 141);
  background: rgb(120, 247, 247);
}

#list-view:hover {
  /* li:hover { */
  background: rgb(115, 172, 172);
}

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
  border-radius: 2px;
  width: 50px;
  height: 50px;
  margin: 5px;
  position: relative;
  transition: all 0.2s ease-in-out;
}

.img-icon {
  width: 80%;
  padding: 2px;
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
  border-radius: 2px;
  border-style: solid;
  border-color: rgb(21, 102, 146);
  background: rgb(21, 102, 146);
  color: rgb(255, 255, 255);

  transition: visibility 0.2s, opacity 0.2s;
}

.selected {
  transform: scale(1.05);
  background: rgb(21, 102, 146, 0.7);
}

.tagSelected {
  border-color: rgb(255, 0, 0) !important;
  background: #ee6c4d !important;
}

.tagSelected:hover {
  border-color: rgb(216, 80, 80) !important;
  background: #e4a191 !important;
}

.languages:hover .label-layer {
  visibility: visible;
  opacity: 1;
}

.label {
  font-size: 1.1em;
  opacity: 1;
}
</style>