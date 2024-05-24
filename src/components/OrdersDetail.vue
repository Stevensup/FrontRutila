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
            <div class="bearer">
                <h1>Detalles de Órdenes</h1>
                <img width="80" height="80" src="../assets/ICONORDEN.png" alt="Imagen">
            </div>
            <input class="search-input" type="text" v-model="search" placeholder="Buscar...">
            <table>
                <thead>
                    <tr>
                        <th>Id</th>
                        <th>Cantidad</th>
                        <th>Bebida</th>
                        <th>Órden</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="filteredAndPaginatedDetails.length === 0">
                        <td colspan="6">
                            <div class="no-results">
                                <img width="250" height="250" src="../assets/tita2.png" alt="Logo de Rutila">
                                <span>Sin registros coincidentes</span>
                            </div>
                        </td>
                    </tr>
                    <tr v-else v-for="detail in filteredAndPaginatedDetails" :key="detail.id">
                        <td>{{ detail.id }}</td>
                        <td>Unidades Disponibles: {{ detail.amount }}</td>
                        <td>{{ detail.drink }}</td>
                        <td>#{{ detail.id_order }}</td>
                        <td>
                            <button class="update"
                                @click="selectedDetail = detail; showUpdateModal = true">Actualizar</button>
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
                <button class="add" @click="showModal = true">Agregar Bebidas</button>
            </div>


            <div v-if="showModal" class="modal">
                <div class="modal-content">
                    <span @click="showModal = false" class="close">&times;</span>
                    <form @submit.prevent="saveDetail" class="form">

                        <label for="productName">Cantidad:</label>
                        <input type="number" id="productName" v-model="detail.amount" required>

                        <label for="drinkSelect">Bebida:</label>
                        <select id="drinkSelect" v-model="detail.id_drink" required>
                            <option v-for="(drink, index) in drinks" :value="drink.id" v-bind:key="index">{{ drink.name
                                }}</option>
                        </select>

                        <label for="orderSelect">Orden:</label>
                        <select id="orderSelect" v-model="detail.id_order" required>
                            <option v-for="(order, index) in orders" :value="order.id" v-bind:key="index">{{ order.id
                                }}</option>
                        </select>

                        <button type="submit">Agregar Detalle</button>
                    </form>
                </div>
            </div>

            <!-- Update Detail Modal -->
            <div v-if="showUpdateModal" class="modal">
                <div class="modal-content">
                    <span @click="showUpdateModal = false" class="close">&times;</span>
                    <form @submit.prevent="updateDetail">

                        <label for="productName">Cantidad:</label>
                        <input type="number" id="productName" v-model="selectedDetail.amount" required> 

                        <label for="quantity">Bebida:</label>
                        <select id="drinkTypeSelect" v-model="selectedDetail.id_drink" required>
                            <option v-for="drink in drinks" :key="drink.id" :value="drink.id">{{ drink.name }}</option>
                        </select>

                        <label for="price">Orden:</label>
                        <select id="orderSelect" v-model="selectedDetail.id_order" required>
                            <option v-for="order in orders" :key="order.id" :value="order.id">{{ order.id }}</option>
                        </select>

                        <button type="submit">Actualizar Detalle</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'OrdersDetail',
    data() {
        return {
            details: [],
            drinks: [],
            ordens: [],
            currentPage: 1,
            itemsPerPage: 5,
            isLoading: false,
            showModal: false,
            showUpdateModal: false,
            selectedDetail: {
                amount: '',
                id_drink: '',
                id_order: ''
            },
            search: '',
            detail: {
                amount: '',
                id_drink: '',
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
        fetchDetails() {
            axios.get('http://localhost:8090/detailsOrder/listar')
                .then(response => { this.details = response.data; })
                .catch(error => { console.error(error); });
        },
        fetchDrinks() {
            axios.get('http://localhost:8090/drink/listar')
                .then(response => { this.drinks = response.data; })
                .catch(error => { console.error(error); });
        },
        fetchOrders() {
            axios.get('http://localhost:8090/order/listar')
                .then(response => { this.orders = response.data; })
                .catch(error => { console.error(error); });
        },
        saveDetail() {
            axios.post('http://localhost:8090/detailsOrder/registrar', this.detail)
                .then(response => {
                    console.log(response.data);
                    this.fetchDetails();
                    this.detail = {
                        amount: '',
                        id_drink: '',
                        id_order: ''
                    };
                })
                .catch(error => {
                    console.error(error);
                })
                .finally(() => {
                    this.showModal = false;
                    this.isLoading = true;
                    setTimeout(() => {
                        this.isLoading = false;
                    }, 750);
                });
        },
        deleteDetail(id) {
            axios.delete(`http://localhost:8090/detailsOrder/eliminar/${id}`)
                .then(response => {
                    console.log(response.data);
                    this.fetchDetails();
                })
                .catch(error => {
                    console.error(error);
                })
                .finally(() => {
                    this.isLoading = true;
                    setTimeout(() => {
                        this.isLoading = false;
                    }, 750);
                });
        },
        updateDetail() {
            axios.put(`http://localhost:8090/detailsOrder/actualizar/${this.selectedDetail.id}`, this.selectedDetail)
                .then(response => {
                    console.log(response.data);

                    const index = this.details.findIndex(detail => detail.id === this.selectedDetail.id);
                    this.details.splice(index, 1, this.selectedDetail);

                    this.showUpdateModal = false;
                })
                .catch(error => {
                    console.error(error);
                })
                .finally(() => {
                    this.isLoading = true;
                    setTimeout(() => {
                        this.isLoading = false;
                    }, 750);
                });
        }
    },
    mounted() {
        this.fetchDetails();
        this.fetchDrinks();
        this.fetchOrders();

    },
    computed: {
        filteredAndPaginatedDetails() {
            const filtered = this.details.filter(detail => {
                return Object.values(detail).some(val => {
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
            const filtered = this.details.filter(detail => {
                return Object.values(detail).some(val => {
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
            return this.details.slice(start, end);
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
    background: #0F5944;
    color: white;
    padding: 15px 10px;
    text-align: left;
}

td {
    border-top: 1px solid #c6c9cc;
    padding: 10px;
}

.add,
.delete,
.update {
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-weight: 500;
    cursor: pointer;
    border-radius: 5px;
    font-size: 1em;
}

.add {
    color: #fff;
    background: #0096FF;
}

.delete {
    color: #fff;
    background: red;
}

.update {
    color: #fff;
    background: green;
}

.loader {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}

.modal {
    display: block;
    position: fixed;
    z-index: 1;
    padding-top: 100px;
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
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
}

.form {
    display: flex;
    flex-direction: column;
}

.form label,
.form input {
    margin-bottom: 10px;
}
</style>