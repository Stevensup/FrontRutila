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
                <h1>Bares</h1>
                <img width="80" height="80" src="../assets/ICONOBAR.png" alt="Imagen">
            </div>
            <input class="search-input" type="text" v-model="search" placeholder="Buscar...">
            <table>
                <thead>
                    <tr>
                        <th>Nombre</th>
                        <th>Dirección</th>
                        <th>Teléfono</th>
                        <th>Horario Apertura</th>
                        <th>Horario Cierre</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="filteredAndPaginatedBars.length === 0">
                        <td colspan="6">
                            <div class="no-results">
                                <img width="250" height="250" src="../assets/tita2.png" alt="Logo de Rutila">
                                <span>Sin registros coincidentes</span>
                            </div>
                        </td>
                    </tr>
                    <tr v-else v-for="bar in filteredAndPaginatedBars" :key="`${bar.name}-${bar.phone}`">
                        <td>{{ bar.name }}</td>
                        <td>{{ bar.location }}</td>
                        <td>{{ bar.phone }}</td>
                        <td>{{ bar.entrytime }}</td>
                        <td>{{ bar.closingtime }}</td>
                        <td>
                            <button class="delete" @click="deleteBar(bar.id)">Eliminar</button>
                            <button class="update" @click="selectedBar = bar; showUpdateModal = true">Actualizar</button>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <button @click="prevPage">Página anterior</button>
                <span>Página {{ currentPage }} de {{ totalPages }}</span>
                <button @click="nextPage">Página siguiente</button>
            </div>
            

                <button class="add" @click="showModal = true">Agregar Bar</button>

                 <!-- Add Bar Modal -->
            <div v-if="showModal" class="modal">
                <div class="modal-content">
                    <span @click="showModal = false" class="close">&times;</span>
                    <form @submit.prevent="saveBar" class="form">
                        <label for="nombre">Nombre:</label>
                        <input type="text" id="nombre" v-model="bar.name" required>

                        <label for="direccion">Dirección:</label>
                        <input type="text" id="direccion" v-model="bar.location" required>

                        <label for="telefono">Teléfono:</label>
                        <input type="text" id="telefono" v-model="bar.phone" required>

                        <label for="horario_apertura">Horario Apertura:</label>
                        <input type="time" id="horario_apertura" v-model="bar.entrytime" required>

                        <label for="horario_cierre">Horario Cierre:</label>
                        <input type="time" id="horario_cierre" v-model="bar.closingtime" required>

                        <button type="submit">Agregar Bar</button>
                    </form>
                </div>
            </div>

            <!-- Update Bar Modal -->
            <div v-if="showUpdateModal" class="modal">
                <div class="modal-content">
                    <span @click="showUpdateModal = false" class="close">&times;</span>
                    <form @submit.prevent="updateBar">
                        <label for="nombre">Nombre:</label>
                        <input type="text" id="nombre" v-model="selectedBar.name" required>

                        <label for="direccion">Dirección:</label>
                        <input type="text" id="direccion" v-model="selectedBar.location" required>

                        <label for="telefono">Teléfono:</label>
                        <input type="text" id="telefono" v-model="selectedBar.phone" required>

                        <label for="horario_apertura">Horario Apertura:</label>
                        <input type="time" id="horario_apertura" v-model="selectedBar.entrytime" required>

                        <label for="horario_cierre">Horario Cierre:</label>
                        <input type="time" id="horario_cierre" v-model="selectedBar.closingtime" required>

                        <button type="submit">Actualizar Bar</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>



<script>
import axios from 'axios';
export default {
    name: 'ListaBares',
    data() {
        return {
            bars: [],
            currentPage: 1,
            itemsPerPage: 5,
            isLoading: false,
            showModal: false,
            showUpdateModal: false,
            selectedBar: {
                id: '',
                name: '',
                location: '',
                phone: '',
                entrytime: '',
                closingtime: ''
            },
            search: '',
            bar: {
                name: '',
                location: '',
                phone: '',
                entrytime: '',
                closingtime: ''
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
        },
        fetchBars() {
            axios.get('http://localhost:8090/pubs/listar')
                .then(response => { this.bars = response.data; })
                .catch(error => { console.error(error); });
        },
        saveBar() {
            axios.post('http://localhost:8090/pubs/registrar', this.bar)
                .then(response => {
                    console.log(response.data);
                    this.fetchBars();
                    this.bar = {
                        nombre: '',
                        direccion: '',
                        telefono: '',
                        horario_apertura: '',
                        horario_cierre: ''
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
        deleteBar(id) {
            axios.put(`http://localhost:8090/pubs/eliminar/${id}`)
                .then(response => {
                    console.log(response.data);
                    this.fetchBars();
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
        // Método para editar un bar
        updateBar() {
            axios.put(`http://localhost:8090/pubs/actualizar/${this.selectedBar.id}`, this.selectedBar)
                .then(response => {
                    console.log(response.data);

                    const index = this.bars.findIndex(bar => bar.id === this.selectedBar.id);
                    this.bars.splice(index, 1, this.selectedBar);

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
        this.fetchBars();
    },
    computed: {
        filteredAndPaginatedBars() {
            const filtered = this.bars.filter(bar => {
                return Object.values(bar).some(val => {
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
            const filtered = this.bars.filter(bar => {
                return Object.values(bar).some(val => {
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
            return this.bars.slice(start, end);
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