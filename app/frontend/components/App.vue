<!-- <template>
  <div>
    <h1>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Distinctio, nam quam! Deleniti praesentium ex
      necessitatibus nulla eveniet quod neque perspiciatis, tempora blanditiis in repellat atque eligendi incidunt!
      Explicabo, sint quo.</h1>
      <span>{{ counter }}</span>
  </div>
</template>

<script>
import { useCounterStore } from '../stores/counter';

const counter = useCounterStore();
export default {
  counter
}
</script>

<style lang="scss" scoped>
h1 {
  color: red;
}</style> -->

<template>
  <div>
    <h1>{{ count }}</h1>
    <h1>{{ count2 }}</h1>
    <div @click="increment">+</div>
    <div @click="decrement">-</div>
    <button @click="reset">o</button>
  </div>
</template>

<script>
import { useCounterStore } from '../stores/counter';
import { storeToRefs } from 'pinia';

export default {
  setup() {
    const counterStore = useCounterStore();
    const { count, count2 } = storeToRefs(counterStore);
    const { increment, decrement, reset } = counterStore;
    return { count, count2, increment, decrement, reset };
  }
}
</script>

<style lang="scss" scoped></style>