<template>
    <div>
        <p>MyInvoices</p>

        <div class="search-bar">
            <input type="text" v-model="search" placeholder="Search Invoices" class="search-input" />
        </div>

        <div v-if="isLoading" class="loader">Loading...</div>

        <div v-if="!isLoading">
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
                    <tr v-for="invoice in paginatedInvoices" :key="invoice.id">
                        <td>{{ invoice.id }}</td>
                        <td>{{ invoice.date }}</td>
                        <td>{{ invoice.total }}</td>
                        <td>{{ orders[invoice.order] ? orders[invoice.order].name : '' }}</td>
                        <td>
                            <button class="update" @click="editInvoice(invoice)">Edit</button>
                            <button class="delete" @click="deleteInvoice(invoice.id)">Delete</button>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <button :disabled="currentPage === 1" @click="currentPage--">Previous</button>
                <span>Page {{ currentPage }}</span>
                <button :disabled="currentPage === totalPages" @click="currentPage++">Next</button>
            </div>
        </div>

        <button class="add" @click="showModal = true">Add Invoice</button>

        <!-- Add Invoice Modal -->
        <div v-if="showModal" class="modal">
            <div class="modal-content">
                <span class="close" @click="showModal = false">&times;</span>
                <form @submit.prevent="saveInvoice">

                    <label for="date">Date:</label>
                    <input type="text" v-model="newInvoice.dates" required />

                    <label for="total">Total:</label>
                    <input type="text" v-model="newInvoice.total" required />

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
                    <input type="text" v-model="selectedInvoice.date" required />

                    <label for="total">Total:</label>
                    <input type="text" v-model="selectedInvoice.total" required />

                    <label for="order">Order:</label>
                    <select v-model="selectedInvoice.order" required>
                        <option v-for="order in orders" :value="order.id" :key="order.id">{{ order.id }}</option>
                    </select>

                    <button type="submit">Update</button>
                </form>
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
    this.isLoading = true;
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
            this.isLoading = true;
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
            this.isLoading = true;
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
    filteredInvoices() {
        return this.invoices.filter(invoice => {
            const id = String(invoice.id);
            const date = String(invoice.date);
            const total = String(invoice.total);
            const orderName = this.orders[invoice.order] ? this.orders[invoice.order].name : '';

            return id.includes(this.search) ||
                   date.includes(this.search) ||
                   total.includes(this.search) ||
                   orderName.includes(this.search);
        });
    },
    paginatedInvoices() {
        const start = (this.currentPage - 1) * this.itemsPerPage;
        const end = start + this.itemsPerPage;
        return this.filteredInvoices.slice(start, end);
    },
    totalPages() {
        return Math.ceil(this.filteredInvoices.length / this.itemsPerPage);
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
    border: 1px solid rgba(224, 224, 224, 1);
}

th,
td {
    text-align: left;
    padding: 16px;
}

th {
    background-color: #f8f8f8;
}

th:first-child {
    border-radius: 10px 0 0 0;
}

th:last-child {
    border-radius: 0 10px 0 0;
}

td:first-child {
    border-radius: 0 0 0 10px;
}

td:last-child {
    border-radius: 0 0 10px 0;
}

button {
    padding: 8px 12px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
}

.add {
    background-color: #00FF00;
    color: #FFFFFF;
}

.update {
    background-color: #FFFF00;
    color: #000000;
}

.delete {
    background-color: #FF0000;
    color: #FFFFFF;
}

.loader {
    text-align: center;
    padding: 20px;
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
    background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
    background-color: #fefefe;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
}

.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}
</style>