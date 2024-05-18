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
    font-size: 2em;
}

p {
    font-size: 1.2em;
}

img {
    margin-top: 20px;
    max-width: 100%;
}
</style>