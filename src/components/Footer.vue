<template>
    <footer class="footer" v-if="$route.name !== 'HelloWorld'">
      <p>© 2024 Rutila</p>
    </footer>
  </template>
  
  <script>
  export default {
    name: 'MyFooter'
  }
  </script>
  
  <style scoped>
  .footer {
    background-color: #0cb6b9;
    color: #0b0505;
    padding: 4px;
    text-align: center;
    font-size: 20px;
    bottom: 0;
    width: 100%;
    position: fixed;
  }
  

  </style>