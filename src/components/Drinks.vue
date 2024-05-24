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
        <div class="container">
            <div class="table-wrapper">
                
                <div class="bearer">
                <h1>Drinks</h1>
                <img width="80" height="80" src="../assets/ICONOBEBIDAS.png" alt="Imagen">
            </div>
                <input class="search-input" type="text" v-model="search" placeholder="Search...">
                <table>
                    <thead>
                        <tr>
                            <th>Nombre</th>
                            <th>Type</th>
                            <th>Price</th>
                            <th>Availability</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="filteredAndPaginatedDrinks.length === 0">
                            <td colspan="6">
                                <div class="no-results">
                                    <img width="250" height="250" src="../assets/tita2.png" alt="Logo de Rutila">
                                    <span>No matching records</span>
                                </div>
                            </td>
                        </tr>
                        <tr v-else v-for="drink in filteredAndPaginatedDrinks" :key="`${drink.name}-${drink.price}`">
                            <td>{{ drink.name }}</td>
                            <td>{{ drink.tipo }}</td>
                            <td>$ {{ drink.price }} COP</td>
                            <td>{{ drink.availability }} Unidades</td>

                            <td>
                                <button class="delete" @click="deleteDrink(drink.id)">Delete</button>
                                <button class="update"
                                    @click="selectedDrink = drink; showUpdateModal = true">Update</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="pagination">
                    <button @click="prevPage">Previous Page</button>
                    <span>Page {{ currentPage }} de {{ totalPages }}</span>
                    <button @click="nextPage">Next Page</button>
                </div>
                <div>
                    <button class="add" @click="showModal = true">Add Drink</button>
                </div>
                <div v-if="showModal" class="modal">
                    <div class="modal-content">
                        <span @click="showModal = false" class="close">&times;</span>
                        <form @submit.prevent="saveDrink" class="form">
                            <label for="nombre">Nombre:</label>
                            <input type="text" id="nombre" v-model="drink.name" required>

                            <label for="drinkTypeSelect">Tipo de Bebida:</label>
                            <select id="drinkTypeSelect" v-model="drink.idtype" required>
                            <option v-for="drinkType in drinkTypes" :key="drinkType.id" :value="drinkType.id">{{ drinkType.types }}</option>
                            </select>

                            <label for="precio">Precio:</label>
                            <input type="text" id="precio" v-model="drink.price" required>

                            <label for="disponibilidad">Disponibilidad:</label>
                            <input type="number" id="disponibilidad" v-model="drink.availability" required>

                            <button type="submit">Agregar Bebida</button>
                        </form>
                    </div>
                </div>
                <div v-if="showUpdateModal" class="modal">
                    <div class="modal-content">
                        <span @click="showUpdateModal = false" class="close">&times;</span>
                        <form @submit.prevent="updateDrinks">
                            <label for="nombre">Nombre:</label>
                            <input type="text" id="nombre" v-model="selectedDrink.name" required>

                            <label for="drinkTypeSelect">Tipo de Bebida:</label>
                            <select id="drinkTypeSelect" v-model="selectedDrink.idtype" required>
                            <option v-for="drinkType in drinkTypes" :key="drinkType.id" :value="drinkType.id">{{ drinkType.types }}</option>
                             </select>


                            <label for="telefono">Precio:</label>
                            <input type="text" id="telefono" v-model="selectedDrink.price" required>

                            <label for="Disponibilidad">Disponibilidad</label>
                            <input type="number" id="Disponibilidad" v-model="selectedDrink.availability" required>

                            <button type="submit">Actualizar Bebidas</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="table-wrapper">
            <DrinksType />
        </div>
        </div>
</template>



<script>
import axios from 'axios';
import './Drinks.css';
import DrinksType from './DrinksType.vue';
export default {
    name: 'MyDrinks',
    components: {
        DrinksType
    },

    data() {
        return {
            
            drinks: [],
            drinkTypes: [],
            currentPage: 1,
            itemsPerPage: 5,
            isLoading: false,
            showModal: false,
            showUpdateModal: false,
            selectedDrink: {
                name: '',
                price: '',
                availability: '',
                idtype: ''
            },
            search: '',
            drink: {
                name: '',
                price: '',
                availability: '',
                idtype: ''
            }
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
        },fetchTypesDrinks() {
    axios.get('http://localhost:8090/typeDrink/listar')
        .then(response => {
            this.drinkTypes = response.data;
        })
        .catch(error => {
            console.error('Error al obtener tipos de bebidas:', error);
        });
},
        fetchDrinks() {
            axios.get('http://localhost:8090/drink/listar')
                .then(response => { this.drinks = response.data; })
                .catch(error => { console.error(error); });
        },
        saveDrink() {
            axios.post('http://localhost:8090/drink/registrar', this.drink)
                .then(response => {
                    console.log(response.data);
                    this.fetchDrinks();
                    this.drink = {
                        name: '',
                        price: '',
                        availability: '',
                        idtype: ''
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
        deleteDrink(id) {
            axios.put(`http://localhost:8090/drink/eliminar/${id}`)
                .then(response => {
                    console.log(response.data);
                    this.fetchDrinks();
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
        updateDrinks() {
            axios.put(`http://localhost:8090/drink/actualizar/${this.selectedDrink.id}`, this.selectedDrink)
            .then(response => {
                console.log('Bebida actualizada', response.data);
                this.showUpdateModal = false;
                this.fetchDrinks(); 
            })
            .catch(error => {
                console.error('Error al actualizar la bebida', error);
            });
    },

    },
    mounted() {
        this.fetchTypesDrinks();
        this.fetchDrinks();
    },
    computed: {
        filteredAndPaginatedDrinks() {
            const filtered = this.drinks.filter(drink => {
                return Object.values(drink).some(val => {
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
            const filtered = this.drinks.filter(drink => {
                return Object.values(drink).some(val => {
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
            return this.drinks.slice(start, end);
        }
    }

};
</script>
