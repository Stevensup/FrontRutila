<template>
    <footer class="footer" v-if="$route.name !== 'HelloWorld'">
      <p>© 2024 Rutila Designe for Steven Useche Senior Developer & Santiago Melo middle Developer</p>
    </footer>
  </template>
  
  <script>
  export default {
    name: 'MyFooter'
  }
  </script>
  
  <style scoped>
  .footer {
    background-color: #0F5944;
    color: #ffffff;
    padding: 0.5px;
    text-align: center;
    font-size: 20px;
    bottom: 0;
    width: 100%;
    position: fixed;
  }
  

  </style>