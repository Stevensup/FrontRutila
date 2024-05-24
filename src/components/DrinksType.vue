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
        <h1>Types of Drinks</h1>
                <input class="search-input" type="text" v-model="searchType" placeholder="Search...">
                <table>
                    <thead>
                        <tr>
                            <th>Id</th>
                            <th>Type</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="filteredAndPaginatedDrinksTypes.length === 0">
                            <td colspan="6">
                                <div class="no-results">
                                    <img width="250" height="250" src="../assets/tita2.png" alt="Logo de Rutila">
                                    <span>No more</span>
                                </div>
                            </td>
                        </tr>
                        <tr v-else v-for="drinkType in filteredAndPaginatedDrinksTypes" :key="`${drinkType.id}-${drinkType.types}`">
                            <td>{{ drinkType.id }}</td>
                            <td>{{ drinkType.types }}</td>
                            <td>
                                <button class="delete" @click="deleteDrinkTypes(drinkType.id)">Delete</button>
                                <button class="update" @click="selectedDrinkType = drinkType; showUpdateModalType = true">Update</button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="pagination">
                    <button @click="prevPageType">Previous Page</button>
                    <span>Page {{ currentPageType }} de {{ totalPagesType }}</span>
                    <button @click="nextPageType">Next Page</button>
                </div>
                <div>
                    <button class="add" @click="showModalType = true">Add Type Drink</button>
                </div>
                <div v-if="showModalType" class="modal">
                    <div class="modal-content">
                        <span @click="showModalType = false" class="close">&times;</span>
                        <form @submit.prevent="saveDrinkType" class="form">
                            <label for="types">Type:</label>
                            <input type="text" id="types" v-model="drinkType.types" required>

                            <button type="submit">Add Type Of Drink:</button>
                        </form>
                    </div>
                </div>
                <div v-if="showUpdateModalType" class="modal">
                    <div class="modal-content">
                        <span @click="showUpdateModalType = false" class="close">&times;</span>
                        <form @submit.prevent="updateDrinksTypes">
    
                            <label for="direccion">Type Of Drink:</label>
                            <input type="text" id="direccion" v-model="selectedDrinkType.types" required>

                            <button type="submit">Update Type Of Drink</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
</template>

<script>
import axios from 'axios';
import './Drinks.css';
export default {
    name: 'MyDrinks',
    data() {
        return {
            drinksTypes: [],
            currentPageType: 1,
            itemsPerPageType: 5,
            isLoading: false,
            showModalType: false,
            showUpdateModalType: false,
            selectedDrinkType: {
                types: ''
            },
            searchType: '',
            drinkType : {
                types: ''
            }
        };
    },
    methods: {
        nextPageType() {
            if (this.currentPageType < this.totalPagesType) {
                this.currentPageType++;
            }
        },
        prevPageType() {
            if (this.currentPageType > 1) {
                this.currentPageType--;
            }
        },
        fetchTypesDrinks() {
            axios.get('http://localhost:8090/typeDrink/listar')
                .then(response => { this.drinksTypes = response.data; })
                .catch(error => { console.error(error); });
        },
        saveDrinkType() {
            axios.post('http://localhost:8090/typeDrink/registrar', this.drinkType)
                .then(response => {
                    console.log(response.data);
                    this.fetchTypesDrinks();
                    this.drinkType = {
                        types: ''
                    };
                })
                .catch(error => {
                    console.error(error);
                })
                .finally(() => {
                    this.showModalType = false;
                    this.isLoading = true;
                    setTimeout(() => {
                        this.isLoading = false;
                    }, 750);
                });
        },
        deleteDrinkTypes(id) {
            axios.put(`http://localhost:8090/typeDrink/eliminar/${id}`)
                .then(response => {
                    console.log(response.data);
                    this.fetchTypesDrinks();
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
        updateDrinksTypes() {
            axios.put(`http://localhost:8090/typeDrink/actualizar/${this.selectedDrinkType.id}`, this.selectedDrinkType)
                .then(response => {
                    console.log(response.data);

                    const index = this.drinksTypes.findIndex(drinkType => drinkType.id === this.selectedDrinkType.id);
                    this.drinksTypes.splice(index, 1, this.selectedDrinkType);

                    this.showUpdateModalType = false;
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
        this.fetchTypesDrinks();
    },
    computed: {
        filteredAndPaginatedDrinksTypes() {
            const filtered = this.drinksTypes.filter(drinkType => {
                return Object.values(drinkType).some(val => {
                    if (val === null || val === undefined) {
                        return false;
                    }

                    const lowerCaseVal = typeof val === 'string' ? val.toLowerCase() : String(val);
                    const lowerCaseSearch = this.searchType.toLowerCase();

                    return lowerCaseVal.includes(lowerCaseSearch);
                });
            });

            const start = (this.currentPageType - 1) * this.itemsPerPageType;
            const end = start + this.itemsPerPageType;

            return filtered.slice(start, end);
        },
        paginatedDataTypes() {
            const start = (this.currentPageType - 1) * this.itemsPerPageType;
            const end = start + this.itemsPerPageType;
            return this.drinksTypes.slice(start, end);
        },
        totalPagesType() {
            const filtered = this.drinksTypes.filter(drinkType => {
                return Object.values(drinkType).some(val => {
                    if (val === null || val === undefined) {
                        return false;
                    }

                    const lowerCaseVal = typeof val === 'string' ? val.toLowerCase() : String(val);
                    const lowerCaseSearch = this.searchType.toLowerCase();

                    return lowerCaseVal.includes(lowerCaseSearch);
                });
            });

            return Math.ceil(filtered.length / this.itemsPerPageType);
        }
    }

};
</script>
