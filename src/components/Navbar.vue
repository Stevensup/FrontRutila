<template>
    <!-- <nav class="navbar"> -->
        <nav class="navbar" v-if="$route.name !== 'HelloWorld'">
        <!-- Aquí va tu código de navbar -->
        <button class="nav-button" @click="$router.push('/Customers')">Customers</button>
        <button class="nav-button" @click="$router.push('/ListaDeBares')">Bares</button>
        <button class="nav-button" @click="$router.push('/ruta3')">Ruta 3</button>
        <button class="nav-button" @click="$router.push('/ruta3')">Ruta 4</button>
    </nav>
</template>

<script>
export default {
    name: 'MyNavbar'

}
</script>

<style scoped>
.navbar {
    /* Aquí van tus estilos para el navbar */
    background-color: #0cb6b9;
    color: #fff;
    padding: 25px;
    display: flex;
    /* Añade esto */
    justify-content: space-around;
    /* Añade esto */
}

.nav-button {
    background-color: #fff;
    color: #000000;
    border: none;
    padding: 10px 20px;
    margin-right: 10px;
    cursor: pointer;
}

.nav-button:hover {
    background-color: #052326;
    color: #fff;
}
</style>