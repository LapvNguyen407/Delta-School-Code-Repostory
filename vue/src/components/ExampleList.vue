<template>
  <div>
    <example-list-item
      v-for="currentExample in filteredExamples"
      v-bind:key="currentExample.example_id"
      :example="currentExample"
    />
  </div>
</template>

<script>
import examplesService from "@/services/ExamplesService.js";
import ExampleListItem from "./ExampleListItem.vue";
export default {
  components: { ExampleListItem },
  name: "all-examples",
  data() {
    return {};
  },
  computed: {
    examples() {
      return this.$store.state.examples;
    },
    filteredExamples() {
      return this.$store.state.examples.filter((example) => {
        if (
          example.title
            .toLowerCase()
            .includes(this.$store.state.filterData.titleFilter.toLowerCase()) ||
          this.$store.state.filterData.titleFilter == ""
        ) {
          if (
            example.language == this.$store.state.filterData.languageFilter ||
            this.$store.state.filterData.languageFilter == "" ||
            this.$store.state.filterData.languageFilter == "All"
          ) {
            if (this.$store.state.filterData.tagsFilter.length > 0) {
              let tagMatch = true;
              this.$store.state.filterData.tagsFilter.forEach((tag) => {
                if (!example.tags.includes(tag)) {
                  tagMatch = false;
                }
              });
              return tagMatch;
            } else {
                return true;
            }
          }
        }
        return false;
      });
    },
  },
  created() {
    examplesService
      .getDefaultExamples()
      .then((response) => {
        this.$store.state.examples = response.data;
      })
      .catch((error) => console.error(error));
  },
};
</script>

<style>
</style>