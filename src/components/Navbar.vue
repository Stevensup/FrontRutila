<template>
    <div class="table-container">
        <nav class="navbar" v-if="$route.name !== 'HelloWorld'">
            <div class="navbar-left">
                <img width="100" height="50" src="../assets/RutilaIcon.png" alt="Rutila Icon" class="nav-icon">
            </div>
            <div class="navbar-right">
                <button class="nav-button" @click="$router.push('/Customers')">Customers</button>
                <button class="nav-button" @click="$router.push('/ListaDeBares')">Bares</button>
                <button class="nav-button" @click="$router.push('/Users')">Users</button>
                <button class="nav-button-logaut" @click="$router.push('/')">Logaut</button>
            </div>
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
    height: calc(10vh - 40px);
    margin-top: 10px;
}

.navbar {
    background-color: #0F5944;
    padding: 5px;
    display: flex;
    justify-content: space-between;
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1000;

}

.navbar-left {
    display: flex;
    align-items: center;
}

.navbar-right {
    display: flex;
    align-items: center;
}
.nav-button {
    background-color: #0F5944;
    color: #fff;
    padding: 10px 20px;
    margin-right: 10px;
    cursor: pointer;
    border: none;
    border-radius: 50px;
}

.nav-button:hover {
    background-color: #F28A2E;
    border: 2px solid #F28A2E;
    color: #fff;
}

.nav-button-logaut {
    background-color: #0F5944;
    color: #fff;
    padding: 10px 20px;
    cursor: pointer;
    border: none;
    border-radius: 50px;
}

.nav-button-logaut:hover {
    background-color: red; /* Cambia el color de fondo a rojo cuando se pasa el mouse por encima */
    border: 2px solid red; /* Cambia el color del borde a rojo cuando se pasa el mouse por encima */
}
</style>