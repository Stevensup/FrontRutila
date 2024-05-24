<template>
    <div class="table-container">
        <nav class="navbar" v-if="$route.name !== 'HelloWorld'">
            <div class="navbar-left">
                <img width="180" height="70" src="../assets/LOGOU.png" alt="Rutila Icon" class="nav-icon">
            </div>
            <div class="navbar-right">
                <button class="nav-button" @click="navigate('/ListaDeBares')">Bares</button>
                <button class="nav-button" @click="navigate('/Customers')">Customers</button>
                <button class="nav-button" @click="navigate('/Users')">Users</button>
                <button class="nav-button" @click="navigate('/Drinks')">Drinks</button>
                <button class="nav-button" @click="navigate('/Orders')">Orders</button>
                <button class="nav-button" @click="navigate('/Invoices')">Invoices</button>
                <button class="nav-button" @click="navigate('/PieChart')">Views</button>
                <button class="nav-button" @click="navigate('/Logs')">Logs</button>
                <button class="nav-button" @click="navigate('/OrdersDetail')">Orders Detail</button>
                <br>
                <img src="../assets/salida.png" class="nav-button-logaut" @click="navigate('/')" />
            </div>
            <div v-if="isLoading" class="loader">
                <div class="flower-spinner">
                    <div class="dots-container">
                        <div class="bigger-dot">
                            <div class="smaller-dot"></div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
    </div>
</template>

<script>
export default {
    name: 'MyNavbar',
    data() {
        return {
            isLoading: false
        }
    },
    methods: {
        navigate(route) {
            this.isLoading = true;
            setTimeout(() => {
                this.$router.push(route);
                this.isLoading = false;
            }, 350); // Cambia este valor para ajustar la duración de la animación
        }
    }
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
    background-color: red;
    /* Cambia el color de fondo a rojo cuando se pasa el mouse por encima */
    border: 2px solid red;
    /* Cambia el color del borde a rojo cuando se pasa el mouse por encima */
}


.flower-spinner,
.flower-spinner * {
    box-sizing: border-box;
}

.flower-spinner {
    height: 70px;
    width: 70px;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
}

.flower-spinner .dots-container {
    height: calc(70px / 7);
    width: calc(70px / 7);
}

.flower-spinner .smaller-dot {
    background: #0cb6b9;
    height: 100%;
    width: 100%;
    border-radius: 50%;
    animation: flower-spinner-smaller-dot-animation 2.5s 0s infinite both;

}

.flower-spinner .bigger-dot {
    background: #0cb6b9;
    height: 100%;
    width: 100%;
    padding: 10%;
    border-radius: 50%;
    animation: flower-spinner-bigger-dot-animation 2.5s 0s infinite both;
}

@keyframes flower-spinner-bigger-dot-animation {

    0%,
    100% {
        box-shadow: rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px;
    }

    50% {
        transform: rotate(180deg);
    }

    25%,
    75% {
        box-shadow: rgb(12, 182, 185) 26px 0px 0px,
            rgb(12, 182, 185) -26px 0px 0px,
            rgb(12, 182, 185) 0px 26px 0px,
            rgb(12, 182, 185) 0px -26px 0px,
            rgb(12, 182, 185) 19px -19px 0px,
            rgb(12, 182, 185) 19px 19px 0px,
            rgb(12, 182, 185) -19px -19px 0px,
            rgb(12, 182, 185) -19px 19px 0px;
    }

    100% {
        transform: rotate(360deg);
        box-shadow: rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px;
    }
}

@keyframes flower-spinner-smaller-dot-animation {

    0%,
    100% {
        box-shadow: rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px;
    }

    25%,
    75% {
        box-shadow: rgb(12, 182, 185) 14px 0px 0px,
            rgb(12, 182, 185) -14px 0px 0px,
            rgb(12, 182, 185) 0px 14px 0px,
            rgb(12, 182, 185) 0px -14px 0px,
            rgb(12, 182, 185) 10px -10px 0px,
            rgb(12, 182, 185) 10px 10px 0px,
            rgb(12, 182, 185) -10px -10px 0px,
            rgb(12, 182, 185) -10px 10px 0px;
    }

    100% {
        box-shadow: rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px,
            rgb(12, 182, 185) 0px 0px 0px;
    }
}
</style>