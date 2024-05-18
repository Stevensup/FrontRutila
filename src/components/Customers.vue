<template>
    <div class="container">
        <div v-if="isLoading" class="loader">
            <div class="flower-spinner">
                <div class="dots-container">
                    <div class="bigger-dot">
                        <div class="smaller-dot"></div>
                    </div>
                </div>
            </div>
            Cargando...
        </div>
        <div class="table-wrapper">
            <input class="search-input" type="text" v-model="search" placeholder="Buscar...">
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Location</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="filteredAndPaginatedCustomers.length === 0">
                        <td colspan="6">
                            <div class="no-results">
                                <img width="250" height="250" src="../assets/tita2.png" alt="Logo de Rutila">
                                <span>Sin registros coincidentes</span>
                            </div>
                        </td>
                    </tr>
                    <tr v-else v-for="customer in filteredAndPaginatedCustomers"
                        :key="`${customer.phone}-${customer.name}`">
                        <td>{{ customer.name }}</td>
                        <td>{{ customer.location }}</td>
                        <td>{{ customer.phone }}</td>
                        <td>{{ customer.email }}</td>
                        <td>
                            <button class="delete" @click="deleteCustomer(customer.id)">Eliminar</button>
                            <button class="update"
                                @click="selectedCustomer = customer; showUpdateModal = true">Actualizar</button>
                            <!-- <button class="updatePassword" @click="updatePassword(customer.id) = customer; showUpdatePasswordModal = true">Actualizar Contraseña</button> -->
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="pagination">
                <button @click="prevPage">Página anterior</button>
                <span>Página {{ currentPage }} de {{ totalPages }}</span>
                <button @click="nextPage">Página siguiente</button>

            </div>
            <div>
                <button @click="showModal = true">Agregar un Cliente</button>
            </div>
            <div v-if="showModal" class="modal">
                <div class="modal-content">
                    <span class="close" @click="showModal = false">&times;</span>
                    <form @submit.prevent="saveCustomer">
                        <label for="name">Name:</label>
                        <input type="text" id="name" v-model="newCustomer.name" required>
                        <label for="location">Location:</label>
                        <input type="text" id="location" v-model="newCustomer.location" required>
                        <label for="phone">Phone:</label>
                        <input type="text" id="phone" v-model="newCustomer.phone" required>
                        <label for="email">Email:</label>
                        <input type="email" id="email" v-model="newCustomer.email" required>
                        <button type="submit">Agregar Cliente</button>
                    </form>
                </div>
            </div>
            <div v-if="showUpdateModal" class="modal">
                <div class="modal-content">
                    <span class="close" @click="showUpdateModal = false">&times;</span>
                    <form @submit.prevent="updateCustomer">
                        <label for="name">Name:</label>
                        <input type="text" id="name" v-model="selectedCustomer.name" required>
                        <label for="location">Location:</label>
                        <input type="text" id="location" v-model="selectedCustomer.location" required>
                        <label for="phone">Phone:</label>
                        <input type="text" id="phone" v-model="selectedCustomer.phone" required>
                        <label for="email">Email:</label>
                        <input type="email" id="email" v-model="selectedCustomer.email" required>
                        <button type="submit">Actualizar Cliente</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>


<script>
import axios from 'axios';
export default {
    name: 'my-customers',
    data() {
        return {
            customers: [],
            currentPage: 1,
            itemsPerPage: 6,
            isLoading: false,
            showModal: false,
            showUpdateModal: false,
            search: '',
            newCustomer: {
                name: '',
                location: '',
                phone: '',
                email: ''
            },
            selectedCustomer: {
                name: '',
                location: '',
                phone: '',
                email: ''
            },

        }
    },
    methods: {
        nextPage() {
            if (this.currentPage < this.totalPages) {
                this.currentPage++;
            }
        },
        prevPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
            }
        },
        fetchCustomers() {
            axios.get('http://localhost:8090/client/listar')
                .then(response => { this.customers = response.data; })
                .catch(error => { console.error(error); });
        },
        saveCustomer() {
            axios.post('http://localhost:8090/client/registrar', this.newCustomer)
                .then(() => {
                    this.fetchCustomers();
                    this.showModal = false;
                    this.newCustomer = {
                        name: '',
                        location: '',
                        phone: '',
                        email: ''
                    };
                })
                .catch(error => { console.error(error); })
                .finally(() => {
                    this.showModal = false;
                    this.isLoading = true;
                    setTimeout(() => {
                        this.isLoading = false;
                    }, 750);
                });

        },
        deleteCustomer(id) {
            axios.put(`http://localhost:8090/client/eliminar/${id}`)
                .then(() => {
                    this.fetchCustomers();
                })
                .catch(error => { console.error(error); })
                .finally(() => {
                    this.isLoading = true;
                    setTimeout(() => {
                        this.isLoading = false;
                    }, 750);
                });
        },
        updateCustomer() {
            axios.put(`http://localhost:8090/client/actualizar/${this.selectedCustomer.id}`, this.selectedCustomer)
                .then(() => {
                    this.fetchCustomers();
                    this.showUpdateModal = false;
                    this.selectedCustomer = {
                        name: '',
                        location: '',
                        phone: '',
                        email: ''
                    };
                })
                .catch(error => { console.error(error); })
                .finally(() => {
                    this.showUpdateModal = false;
                    this.isLoading = true;
                    setTimeout(() => {
                        this.isLoading = false;
                    }, 750);
                });
        }


    },
    mounted() {
        this.fetchCustomers();
    },
    computed: {
        filteredAndPaginatedCustomers() {
            const filtered = this.customers.filter(customer => {
                return Object.values(customer).some(val => {
                    if (val === null || val === undefined) {
                        return false;
                    }

                    const lowerCaseVal = typeof val === 'string' ? val.toLowerCase() : String(val);
                    const lowerCaseSearch = this.search.toLowerCase();

                    return lowerCaseVal.includes(lowerCaseSearch);
                });
            });

            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;

            return filtered.slice(start, end);
        },
        totalPages() {
            const filtered = this.customers.filter(customer => {
                return Object.values(customer).some(val => {
                    if (val === null || val === undefined) {
                        return false;
                    }

                    const lowerCaseVal = typeof val === 'string' ? val.toLowerCase() : String(val);
                    const lowerCaseSearch = this.search.toLowerCase();

                    return lowerCaseVal.includes(lowerCaseSearch);
                });
            });

            return Math.ceil(filtered.length / this.itemsPerPage);
        }
    }

}
</script>

<style scoped>
.no-results {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.no-results span {
    font-size: 2em;
    /* Ajusta este valor para cambiar el tamaño del texto */
}

.search-input {
    background-color: #ffffff;
    outline: none;
    border: none;
    font-weight: bold;
}

.search-input::placeholder {
    font-weight: bold;
}


body {
    font-family: Helvetica Neue, Arial, sans-serif;
    font-size: 14px;
}

table {
    border: 2px solid #0F5944;
    border-radius: 3px;
    background-color: #fff;
}

th {
    background-color: #0F5944;
    color: rgba(255, 255, 255, 0.66);
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
}

td {
    background-color: #f9f9f9;
}

th,
td {
    min-width: 120px;
    padding: 10px 20px;
}

th.active {
    color: #fff;
}

th.active .arrow {
    opacity: 1;
}

.arrow {
    display: inline-block;
    vertical-align: middle;
    width: 0;
    height: 0;
    margin-left: 5px;
    opacity: 0.66;
}

.arrow.asc {
    border-left: 4px solid transparent;
    border-right: 4px solid transparent;
    border-bottom: 4px solid #fff;
}

.arrow.dsc {
    border-left: 4px solid transparent;
    border-right: 4px solid transparent;
    border-top: 4px solid #fff;
}


.pagination {
    display: flex;
    justify-content: space-between;
    padding: 1em 0;
}

.container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 80vh;
}

.table-wrapper {
    background-color: #fff;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
    text-align: center;
}

thead {
    background-color: #f8f9fa;
}

th,
td {
    padding: 10px;
    text-align: left;
    border-bottom: 1px solid #ddd;
    text-align: center;
}

tr:hover {
    background-color: #f5f5f5;
}

button {
    background-color: #0F5944;
    /* Green */
    border: none;
    color: white;
    padding: 10px 20px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 4px 2px;
    cursor: pointer;
    transition-duration: 0.4s;
}

button:hover {
    background-color: #F28A2E;
}

form {
    display: flex;
    flex-direction: column;
    width: 100%;
    max-width: 400px;
    margin: auto;
}

label {
    font-weight: bold;
    margin-top: 10px;
}

input[type="text"] {
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    margin-top: 5px;
}

button[type="submit"] {
    background-color: #4CAF50;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    margin-top: 10px;
}

button[type="submit"]:hover {
    background-color: #2614a1;
}

.modal {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
    background-color: #fefefe;
    margin: auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
}

.close {
    color: #aaaaaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
}

.modal {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
    background-color: #fefefe;
    margin: auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
}

.close {
    color: #aaaaaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
}

.loader {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.8);
    /* Aumenta la opacidad para oscurecer el fondo */
    color: white;
    font-size: 48px;
    /* Aumenta el tamaño de la fuente */
}

.delete {
    background-color: #F28A2E;

}

.update {
    background-color: #11BFBF;

}

.add {
    background-color: #90BF2A;

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