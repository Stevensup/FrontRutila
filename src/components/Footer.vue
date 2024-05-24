<template>
  <footer class="footer" v-if="$route.name !== 'HelloWorld'">
    <div class="footer-content">
      <p>© 2024 Rutila Designe for Steven Useche Senior Developer & Santiago Melo middle Developer</p>
      <button class="floating-button" @click="goToPDFView">Factura PDF Aqui!</button>
    </div>
  </footer>
</template>

<script>
export default {
name: 'MyFooter',
methods: {
  goToPDFView() {
    this.$router.push('/pdf');
  }
}
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

.footer-content {
position: relative;
display: flex;
justify-content: center;
align-items: center;
}

.floating-button {
position: absolute;
right: 10px;
background-color: #F28A2E;
color: #ffffff;
border: none;
padding: 15px;
font-size: 20px;
cursor: pointer;
}
</style>