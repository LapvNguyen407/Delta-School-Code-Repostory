<template>
  <div id="example">
    <div id="example-list">
      <example-list id="child" />
    </div>
    <div id="current-example">
      <example-item />
    </div>
    <div id="search-box">
      <search-tab />
    </div>
  </div>
</template>

<script>
import ExampleList from "../components/ExampleList.vue";
import ExampleItem from "@/components/ExampleItem.vue";
import SearchTab from "../components/SearchTab.vue";

export default {
  components: { ExampleList, ExampleItem, SearchTab },
  name: "example",
  data() {
    return {
    };
  },
};
</script>

<style>
#example {
  display: flex;
  flex-grow: 1;
  justify-content: center;
  align-items: space-between;
  height: 80vh;
}

#example-list {
  height: 100%;
  overflow-y: auto;
  transform: scaleX(-1);
  flex-grow: 1;
  width: 20vw;

  border-style: solid;
  border-color: rgb(12, 168, 173);
  border-width: 2px;
  border-radius: 7px;

  background: rgb(214, 217, 218);
}

#child {
  transform: scaleX(-1);
}

/* width */
::-webkit-scrollbar {
  width: 20px;
}

/* Track */
::-webkit-scrollbar-track {
  background: rgb(150, 183, 189);
}

/* Handle */
::-webkit-scrollbar-thumb {
  background: rgb(60, 161, 233);
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: rgb(4, 95, 145);
}

#current-example {
  border-style: solid;
  border-color: rgb(12, 168, 173);
  padding: 2%;
  margin: 2px;
  border-width: 2px;
  border-radius: 7px;
  background: rgb(214, 217, 218);
  width: 60vw;
  flex-grow: 1;
  overflow-y: auto;
}

#search-box {
  border-style: solid;
  border-color: rgb(12, 168, 173);
  padding: 1%;
  margin: 2px;
  border-width: 2px;
  border-radius: 7px;
  background: rgb(214, 217, 218);
  flex-grow: 1;
  width: 20vw;
}
</style>