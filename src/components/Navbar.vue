<template>
        <nav class="navbar" v-if="$route.name !== 'HelloWorld'">
        <button class="nav-button" @click="$router.push('/Customers')">Customers</button>
        <button class="nav-button" @click="$router.push('/ListaDeBares')">Bares</button>
        <button class="nav-button" @click="$router.push('/Users')">Users</button>
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
    background-color: #0cb6b9;
    padding: 10px;
    display: flex;
    justify-content: space-around;
    
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