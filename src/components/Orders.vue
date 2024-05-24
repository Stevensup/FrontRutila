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
            Loading...
        </div>
        <div class="table-wrapper">
            <div class="bearer">
                <h1>Orders</h1>
                <img width="80" height="80" src="../assets/ICONORDEN.png" alt="Imagen">
            </div>
            <input class="search-input" type="text" v-model="search" placeholder="Search...">

            <table class="table">
                <thead>
                    <tr>
                        <th>Id</th>
                        <th>Date</th>
                        <th>Client</th>
                        <th>Pubs</th>
                        <th>User</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                       <tr v-if="filteredAndPaginatedOrders.length === 0">
                        <td colspan="6">
                            <div class="no-results">
                                <img width="250" height="250" src="../assets/tita2.png" alt="Logo de Rutila">
                                <span>No matching records</span>
                            </div>
                        </td>
                    </tr>
                    <tr v-for="order in filteredAndPaginatedOrders" :key="`${order.id}-${order.dates}-${customers.name}`">
                        <td>{{ order.id }}</td>
                        <td>{{ order.dates }}</td>
                        <td>{{ customers[order.idcustomers] }}</td>
                        <td>{{ bars[order.idpubs] }}</td>
                        <td>{{ users[order.idusers] }}</td>
                        <td>
                            <button class="update" @click="editOrder(order)">Update</button>
                            <button class="delete" @click="deleteOrder(order.id)">Delete</button>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <button @click="prevPage">Previous Page</button>
                <span>Page {{ currentPage }} de {{ totalPages }}</span>
                <button @click="nextPage">Next Page</button>
            </div>

            <button class="add" @click="showModal = true">Add Order</button>

        <!-- Modal para agregar nueva factura -->
        <div v-if="showModal" class="modal">
            <div class="modal-content">
                <span class="close" @click="showModal = false">&times;</span>
                <h2>Agregar Nueva Factura</h2>
                <form @submit.prevent="saveOrder">
                    <div>
                        <label for="dates">Fecha:</label>
                        <input type="date" v-model="newOrder.dates" required>
                    </div>
                    <div>
                        <label for="idcustomers">Cliente:</label>
                        <select v-model="newOrder.idcustomers" required>
                            <option v-for="(name, id) in customers" :key="id" :value="id">{{ name }}</option>
                        </select>
                    </div>
                    <div>
                        <label for="idpubs">Bar:</label>
                        <select v-model="newOrder.idpubs" required>
                            <option v-for="(name, id) in bars" :key="id" :value="id">{{ name }}</option>
                        </select>
                    </div>
                    <div>
                        <label for="idusers">Usuario:</label>
                        <select v-model="newOrder.idusers" required>
                            <option v-for="(name, id) in users" :key="id" :value="id">{{ name }}</option>
                        </select>
                    </div>
                    <button type="submit">Guardar</button>
                </form>
            </div>
        </div>
        
        <!-- Modal para editar factura existente -->
        <div v-if="showUpdateModal" class="modal">
            <div class="modal-content">
                <span class="close" @click="showUpdateModal = false">&times;</span>
                <h2>Editar Factura</h2>
                <form @submit.prevent="updateOrder">
                    <div>
                        <label for="dates">Fecha:</label>
                        <input type="date" v-model="SelectedOrder.dates" required>
                    </div>
                    <div>
                        <label for="idcustomers">Cliente:</label>
                        <select v-model="SelectedOrder.idcustomers" required>
                            <option v-for="(name, id) in customers" :key="id" :value="id">{{ name }}</option>
                        </select>
                    </div>
                    <div>
                        <label for="idpubs">Bar:</label>
                        <select v-model="SelectedOrder.idpubs" required>
                            <option v-for="(name, id) in bars" :key="id" :value="id">{{ name }}</option>
                        </select>
                    </div>
                    <div>
                        <label for="idusers">Usuario:</label>
                        <select v-model="SelectedOrder.idusers" required>
                            <option v-for="(name, id) in users" :key="id" :value="id">{{ name }}</option>
                        </select>
                    </div>
                    <button type="submit">Guardar</button>
                </form>
            </div>
        </div>

        <!-- Modal para ver la factura -->
        <div v-if="showModalFactura" class="modal">
            <div class="modal-content" id="invoice">
                <span class="close" @click="showModalFactura = false">&times;</span>
                <h2>Factura</h2>
                <img src="../assets/tita2.png" alt="Logo Empresa" class="logo">
                <div class="invoice-details">
                    <p><strong>Cliente:</strong> {{ customers[SelectedOrder.idcustomers] }}</p>
                    <p><strong>Bar:</strong> {{ bars[SelectedOrder.idpubs] }}</p>
                    <p><strong>Usuario:</strong> {{ users[SelectedOrder.idusers] }}</p>
                    <p><strong>Fecha:</strong> {{ SelectedOrder.dates }}</p>
                    <p><strong>ID de Orden:</strong> {{ SelectedOrder.id }}</p>
                </div>
                <button @click="exportPDF">Exportar a PDF</button>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import axios from 'axios';
export default {
    name: 'MyOrders',
    data() {
        return {
            orders: [],
            currentPage: 1,
            itemsPerPage: 6,
            isLoading: false,
            showModal: false,
            showModalFactura: false,
            showUpdateModal: false,
            customers: [],
            bars: [],
            users: [],
            search: '',
            newOrder: {
                dates: '',
                idcustomers: '',
                idpubs: '',
                idusers: '',
            },
            SelectedOrder: {
                dates: '',
                idcustomers: '',
                idpubs: '',
                idusers: '',
            }
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
        fetchOrders() {
        axios.get('http://localhost:8090/order/listar')
            .then(response => { this.orders = response.data; })
            .catch(error => { console.error(error); });
    },
    fetchCustomers() {
        axios.get('http://localhost:8090/client/listar')
            .then(response => {
                this.customers = response.data.reduce((acc, customer) => {
                    acc[customer.id] = customer.name;
                    return acc;
                }, {});
            })
            .catch(error => { console.error(error); });
    },
    fetchBars() {
        axios.get('http://localhost:8090/pubs/listar')
            .then(response => {
                this.bars = response.data.reduce((acc, bar) => {
                    acc[bar.id] = bar.name;
                    return acc;
                }, {});
            })
            .catch(error => { console.error(error); });
    },
    fetchUsers() {
        axios.get('http://localhost:8090/user/listar')
            .then(response => {
                this.users = response.data.reduce((acc, user) => {
                    acc[user.id] = user.name;
                    return acc;
                }, {});
            })
            .catch(error => { console.error(error); });
    },
    saveOrder() {
            axios.post('http://localhost:8090/order/registrar', this.newOrder)
                .then(() => {
                    this.fetchOrders();
                    this.newOrder = {
                        dates: '',
                        idcustomers: '',
                        idpubs: '',
                        idusers: '',
                    };
                })
                .catch(error => { console.error(error); })
                .finally(() => {
                    this.showModal = false;
                    this.isLoading = true;
                    setTimeout(() => { this.isLoading = false; }, 750);
                });
        },
        updateOrder() {
            axios.put(`http://localhost:8090/order/actualizar/${this.SelectedOrder.id}`, this.SelectedOrder)
                .then(() => {
                    this.fetchOrders();
                    this.SelectedOrder = {
                        dates: '',
                        idcustomers: '',
                        idpubs: '',
                        idusers: '',
                    };
                })
                .catch(error => { console.error(error); })
                .finally(() => {
                    this.showUpdateModal = false;
                    this.isLoading = true;
                    setTimeout(() => { this.isLoading = false; }, 750);
                });
        },
        deleteOrder(id) {
            axios.put(`http://localhost:8090/order/eliminar/${id}`)
                .then(() => {
                    this.fetchOrders();
                })
                .catch(error => { console.error(error); })
                .finally(() => {
                    this.showUpdateModal = false;
                    this.isLoading = true;
                    setTimeout(() => { this.isLoading = false; }, 750);
                });
        },
        editOrder(order) {
            this.SelectedOrder = { ...order };
            this.showUpdateModal = true;
        }
    },
    mounted() {
        this.fetchOrders();
        this.fetchCustomers();
        this.fetchBars();
        this.fetchUsers();
    },
    computed: {
        filteredAndPaginatedOrders() {
            const filtered = this.orders.filter(order => {
                return Object.values(order).some(val => {
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
            const filtered = this.orders.filter(order => {
                return Object.values(order).some(val => {
                    if (val === null || val === undefined) {
                        return false;
                    }

                    const lowerCaseVal = typeof val === 'string' ? val.toLowerCase() : String(val);
                    const lowerCaseSearch = this.search.toLowerCase();

                    return lowerCaseVal.includes(lowerCaseSearch);
                });
            });

            return Math.ceil(filtered.length / this.itemsPerPage);
        },
        paginatedData() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.orders.slice(start, end);
        }

    }

};
</script>

<style scoped>
.table-container {
    display: flex;
    justify-content: space-between;
}

.bearer {
    display: flex;
    align-items: center;
}



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
    margin-right: 20px;
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

 h1{
        color: #F28A2E;
        font-size: 3em;
        text-transform: uppercase;
    
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
