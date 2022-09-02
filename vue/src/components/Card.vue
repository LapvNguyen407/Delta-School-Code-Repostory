<template>
  <div
    :id="id"
    class="card"
    :draggable="draggable"
    @dragstart.self="dragStart"
    @dragover.stop
  >
    <slot />
  </div>
</template>

<script>
import exampleService from "@/services/ExamplesService";

export default {
  props: ["id", "draggable"],
  methods: {
    dragStart(event) {
      const target = event.target;

      let currentExample = this.$store.state.userExamples.filter(
        (item) => item.example_id == target.id
      );

      if (currentExample[0].status === "PRIVATE") {
        exampleService.submitExampleForApproval(target.id).then((response) => {
          this.$store.commit("SET_USER_EXAMPLES", response.data);
          exampleService.getUserExamples().then((response) => {
            this.$store.commit("SET_USER_EXAMPLES", response.data);
            location.reload();
          });
        });
      } else {
        exampleService.redactExampleForApproval(target.id).then((response) => {
          this.$store.commit("SET_USER_EXAMPLES", response.data);
          exampleService.getUserExamples().then((response) => {
            this.$store.commit("SET_USER_EXAMPLES", response.data);
            location.reload();
          });
        });
      }

      event.dataTransfer.setData("card_id", target.id);
    },
  },
};
</script>
