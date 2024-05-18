import { createRouter, createWebHistory } from "vue-router";
import HelloWorld from "./components/HelloWorld.vue";
import ListaDeBares from "./components/ListaDeBares.vue";
import Customers from "./components/Customers.vue";
import Users from "./components/Users.vue";

const routes = [
  {
    path: "/",
    name: "HelloWorld",
    component: HelloWorld,
  },
  {
    path: "/ListaDeBares",
    name: "ListaDeBares",
    component: ListaDeBares,
  },
  {
    path: "/Customers",
    name: "Customers",
    component: Customers,
  },
  {
    path: "/Users",
    name: "Users",
    component: Users
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
