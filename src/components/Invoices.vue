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
                <h1>Invoices</h1>
                <img width="80" height="80" src="../assets/ICONOFACTURA.png" alt="Imagen">
            </div>
            <input class="search-input" type="text" v-model="search" placeholder="Search...">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date</th>
                        <th>Total</th>
                        <th>Order</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="filteredAndPaginatedInvoices.length === 0">
                        <td colspan="6">
                            <div class="no-results">
                                <img width="250" height="250" src="../assets/tita2.png" alt="Logo de Rutila">
                                <span>No matching records</span>
                            </div>
                        </td>
                    </tr>
                    <tr v-for="invoice in filteredAndPaginatedInvoices" :key="invoice.id">
                        <td>{{ invoice.id }}</td>
                        <td>{{ invoice.dates }}</td>
                        <td>$ {{ invoice.total }}</td>
                        <td># Orden {{ orders[invoice.id_order] ? orders[invoice.id_order].id : '' }}</td>
                        <td>
                            <button class="delete" @click="deleteInvoice(invoice.id)">Delete</button>
                            <button class="update"
                                @click="selectedInvoice = invoice; showUpdateModal = true">Update</button>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <button :disabled="currentPage === 1" @click="currentPage--">Previous</button>
                <span>Page {{ currentPage }}</span>
                <button :disabled="currentPage === totalPages" @click="currentPage++">Next</button>
            </div>

            <button class="add" @click="showModal = true">Add Invoice</button>

            <!-- Add Invoice Modal -->
            <div v-if="showModal" class="modal">
                <div class="modal-content">
                    <span class="close" @click="showModal = false">&times;</span>
                    <form @submit.prevent="saveInvoice">

                        <label for="date">Date:</label>
                        <input type="date" v-model="newInvoice.dates" required />

                        <label for="total">Total:</label>
                        <input type="number" v-model="newInvoice.total" required />

                        <label for="order">Order:</label>
                        <select v-model="newInvoice.id_order" required>
                            <option v-for="order in orders" :value="order.id" :key="order.id">{{ order.id }}</option>
                        </select>
                        <button type="submit">Save</button>
                    </form>
                </div>
            </div>

            <!-- Update Invoice Modal -->
            <div v-if="showUpdateModal" class="modal">
                <div class="modal-content">
                    <span class="close" @click="showUpdateModal = false">&times;</span>
                    <form @submit.prevent="updateInvoice">
                        <label for="id">ID:</label>
                        <input type="text" v-model="selectedInvoice.id" required disabled />

                        <label for="date">Date:</label>
                        <input type="date" v-model="selectedInvoice.dates" required />

                        <label for="total">Total:</label>
                        <input type="text" v-model="selectedInvoice.total" required />

                        <label for="order">Order:</label>
                        <select v-model="selectedInvoice.order" required>
                            <option v-for="order in orders" :value="order.id_order" :key="order.id">{{ order.id }}</option>
                        </select>

                        <button type="submit">Update Bar</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'MyInvoices',
    data() {
        return {
            invoices: [],
            orders: [],
            currentPage: 1,
            itemsPerPage: 5,
            isLoading: false,
            showModal: false,
            showUpdateModal: false,
            search: '',
            newInvoice: {
                id: '',
                date: '',
                total: '',
                id_order: ''
            },
            selectedInvoice: {
                dates: '',
                total: '',
                id_order: ''
            },
        };
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
        fetchInvoices() {
            this.isLoading = true;
            axios.get('http://localhost:8090/invoice/listar')
                .then(response => {
                    this.invoices = response.data;
                })
                .catch(error => {
                    console.error(error);
                })
                .finally(() => {
                    this.isLoading = false;
                });
        },
        fetchOrders() {
            this.isLoading = true;
            axios.get('http://localhost:8090/order/listar')
                .then(response => {
                    this.orders = response.data.reduce((acc, order) => {
                        acc[order.id] = order;
                        return acc;
                    }, {});
                })
                .catch(error => {
                    console.error(error);
                })
                .finally(() => {
                    this.isLoading = false;
                });
        },
        saveInvoice() {
            axios.post('http://localhost:8090/invoice/registrar', this.newInvoice)
                .then(() => {
                    this.fetchInvoices();
                    this.newInvoice = {
                        id: 0,
                        total: '',
                        dates: '',
                        id_order: ''
                    };
                    this.showModal = false;
                })
                .catch(error => {
                    console.error(error);
                })
                .finally(() => {
                    this.isLoading = false;
                });
        },
        updateInvoice() {
            axios.put(`http://localhost:8090/invoice/actualizar/${this.selectedInvoice.id}`, this.selectedInvoice)
                .then(() => {
                    this.fetchInvoices();
                    this.selectedInvoice = {
                        dates: '',
                        total: '',
                        id_order: ''
                    };
                    this.showUpdateModal = false;
                })
                .catch(error => {
                    console.error(error);
                })
                .finally(() => {
                    this.isLoading = false;
                });
        },
        deleteInvoice(id) {
            axios.put(`http://localhost:8090/invoice/eliminar/${id}`)
                .then(() => {
                    this.fetchInvoices();
                })
                .catch(error => {
                    console.error(error);
                })
                .finally(() => {
                    this.isLoading = false;
                });
        },
        editInvoice(invoice) {
            this.selectedInvoice = { ...invoice };
            this.showUpdateModal = true;
        },
    },
    mounted() {
        this.fetchInvoices();
        this.fetchOrders();
    },
    computed: {
        filteredAndPaginatedInvoices() {
            const filtered = this.invoices.filter(invoice => {
                return Object.values(invoice).some(val => {
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
            const filtered = this.invoices.filter(invoice => {
                return Object.values(invoice).some(val => {
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
            return this.invoices.slice(start, end);
        }
    }

};
</script>

<style scoped>
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