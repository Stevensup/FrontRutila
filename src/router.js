import { createRouter, createWebHistory } from "vue-router";
import HelloWorld from "./components/HelloWorld.vue";
import ListaDeBares from "./components/Bars.vue";
import Customers from "./components/Customers.vue";
import Users from "./components/Users.vue";
import Welcome from "./components/Welcome.vue"; 


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
    component: Users,
  },
  {
    path: "/Welcome",
    name: "Welcome",
    component: Welcome,
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
