import { createRouter, createWebHistory } from "vue-router";
import HelloWorld from "./components/HelloWorld.vue";
import ListaDeBares from "./components/Bars.vue";
import Customers from "./components/Customers.vue";
import Users from "./components/Users.vue";
import Welcome from "./components/Welcome.vue";
import Drinks from "./components/Drinks.vue";
import DrinksType from "./components/DrinksType.vue";
import Invoices from "./components/Invoices.vue";
import Orders from "./components/Orders.vue";
import PieChart from "./components/PieChart.vue";

const routes = [
  {
    path: "/",
    name: "HelloWorld",
    component: HelloWorld
  },
  {
    path: "/ListaDeBares",
    name: "ListaDeBares",
    component: ListaDeBares
  },
  {
    path: "/Customers",
    name: "Customers",
    component: Customers
  },
  {
    path: "/Users",
    name: "Users",
    component: Users
  },
  {
    path: "/Welcome",
    name: "Welcome",
    component: Welcome
  },
  {
    path: "/Drinks",
    name: "Drinks",
    component: Drinks
  },
  {
    path: "/DrinksType",
    name: "DrinksType",
    component: DrinksType
  },
  {
    path: "/Invoices",
    name: "Invoices",
    component: Invoices
  },
  {
    path: "/Orders",
    name: "Orders",
    component: Orders
  },
  {
    path:"/PieChart",
    name:"PieChart",
    component: PieChart
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
