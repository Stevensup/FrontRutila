<template>
    <div class="bienvenida">
        <div class="text-container">
            <h1>Welcome  to Rutila</h1>
        </div>
        <img src="../assets/tila1.jpg" alt="Logo de Rutila">
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
    position: relative;
    background-color: white;
}

.text-container {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    text-align: center;
}

h1 {
    font-size: 6em;
    color: #000000; /* Cambia este color según tu diseño */
    text-shadow: 0 0 10px #12beb5, 0 0 20px #00ff00, 0 0 30px #12beb5, 0 0 40px #12beb5, 0 0 50px #12beb5, 0 0 60px #12beb5, 0 0 70px #12beb5;
}


.introduccion {
    color: #888181;
    font-size: 1.5em;
    line-height: 1.6;
    margin-top: 20px;
}

img {
    width: 70%;
    height: auto;
}
</style>