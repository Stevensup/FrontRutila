<template>
    <div class="bienvenida">
        <h1>Bienvenido a Rutila</h1>
        <p>aca encontraras la gestion de todos los bares de la ciudad</p>
        <img width="500" height="500" src="../assets/tita2.png" alt="Logo de Rutila">

    </div>
</template>

<script>
export default {
    name: 'MyBienvenida'
}
</script>

<style scoped>
.bienvenida {
    padding: 20px;
    text-align: center;
    background-color: white;
}

h1 {
    font-size: 6em;
    color: #ffffff;
    text-shadow: 0 0 10px #12beb5, 0 0 20px #00ff00, 0 0 30px #12beb5, 0 0 40px #12beb5, 0 0 50px #12beb5, 0 0 60px #12beb5, 0 0 70px #12beb5;
    
}

p {
    font-size: 1.2em;
}

img {
    margin-top: 20px;
    max-width: 100%;
}
</style>