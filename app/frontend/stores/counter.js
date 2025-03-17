import { defineStore } from "pinia";

export const useCounterStore = defineStore("counter", {
  state: () => ({
    count: 0,
    count2: 0,
  }),
  actions: {
    increment() {
      this.count++;
      this.count2++;
    },
    decrement() {
      this.count--;
      this.count2--;
    },
    reset() {
      this.$reset();
    },
  },
  getters: {
    doubleCount: (state) => {
      return state.count * 2;
    },
  },
  // persist: true,
  persist: {
    storage: sessionStorage, // Sử dụng session storage thay vì local storage
    paths: ['state.count'], // Chỉ lưu trữ thuộc tính 'count'
  },
});
