<template>
    <div class="table-container">
        <nav class="navbar" v-if="$route.name !== 'HelloWorld'">
        <button class="nav-button" @click="$router.push('/Customers')">Customers</button>
        <button class="nav-button" @click="$router.push('/ListaDeBares')">Bares</button>
        <button class="nav-button" @click="$router.push('/Users')">Users</button>
        <button class="nav-button" @click="$router.push('/ruta3')">Ruta 4</button>
    </nav>
    </div>
</template>

<script>
export default {
    name: 'MyNavbar'

}
</script>

<style scoped>

.table-container {
    overflow: auto;
    height: calc(10vh - 40px); /* Ajusta este valor según la altura de tu navbar */
    margin-top: 10px; /* Ajusta este valor según la altura de tu navbar */
}

.navbar {
    background-color: #0cb6b9;
    padding: 10px;
    display: flex;
    justify-content: space-around;
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1000;
    
}

.nav-button {
    background-color: transparent;
    color: #fff;
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