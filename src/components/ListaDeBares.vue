<template>
    <div class="container">
        <!-- <div v-if="isLoading" class="loader">Cargando...</div> -->
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
            <input type="text" v-model="search" placeholder="Buscar...">
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
                    <tr v-for="bar in filteredBars" :key="`${bar.name}-${bar.phone}`">
                        <td>{{ bar.name }}</td>
                        <td>{{ bar.location }}</td>
                        <td>{{ bar.phone }}</td>
                        <td>{{ bar.entrytime }}</td>
                        <td>{{ bar.closingtime }}</td>
                        <td>
                            <button class="delete" @click="deleteBar(bar.id)">Eliminar</button>
                            <button class="update"
                                @click="selectedBar = bar; showUpdateModal = true">Actualizar</button>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div>
                <button @click="showModal = true">Agregar Bar</button>
            </div>
            <div v-if="showModal" class="modal">
                <div class="modal-content">
                    <span @click="showModal = false" class="close">&times;</span>
                    <form @submit.prevent="saveBar">
                        <label for="nombre">Nombre:</label>
                        <input type="text" id="nombre" v-model="bar.name" required>

                        <label for="direccion">Dirección:</label>
                        <input type="text" id="direccion" v-model="bar.location" required>

                        <label for="telefono">Teléfono:</label>
                        <input type="text" id="telefono" v-model="bar.phone" required>

                        <label for="horario_apertura">Horario Apertura:</label>
                        <input type="text" id="horario_apertura" v-model="bar.entrytime" required>

                        <label for="horario_cierre">Horario Cierre:</label>
                        <input type="text" id="horario_cierre" v-model="bar.closingtime" required>

                        <button type="submit">Guardar</button>
                    </form>
                </div>
            </div>
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
                        <input type="text" id="horario_apertura" v-model="selectedBar.entrytime" required>

                        <label for="horario_cierre">Horario Cierre:</label>
                        <input type="text" id="horario_cierre" v-model="selectedBar.closingtime" required>

                        <button type="submit">Actualizar</button>
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
            bars: [],
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
        // Método para obtener la lista de bares desde el servidor
        fetchBars() {
            // Aquí va la lógica para hacer la petición HTTP y obtener los bares
            axios.get('http://localhost:8090/pubs/listar')
                .then(response => { this.bars = response.data; })
                .catch(error => { console.error(error); });
        },
        // Método para guardar un nuevo bar en el servidor
        saveBar() {
            axios.post('http://localhost:8090/pubs/guardarbar', this.bar)
                .then(response => {
                    // Aquí puedes manejar la respuesta del servidor después de guardar el bar
                    console.log(response.data);
                    // Actualizar la lista de bares después de guardar uno nuevo
                    this.fetchBars();
                    // Reiniciar el formulario
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
        // Método para eliminar un bar en el servidor
        deleteBar(id) {
            axios.put(`http://localhost:8090/pubs/eliminar/${id}`)
                .then(response => {
                    // Aquí puedes manejar la respuesta del servidor después de eliminar el bar
                    console.log(response.data);
                    // Actualizar la lista de bares después de eliminar uno
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
            axios.put(`http://localhost:8090/pubs/${this.selectedBar.id}`, this.selectedBar)
                .then(response => {
                    // Aquí puedes manejar la respuesta del servidor después de editar el bar
                    console.log(response.data);

                    // Actualiza la lista de bares con los datos actualizados del bar
                    const index = this.bars.findIndex(bar => bar.id === this.selectedBar.id);
                    this.bars.splice(index, 1, this.selectedBar);

                    // Cierra el modal de actualización
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
        // Llamar al método fetchBars al cargar el componente
        this.fetchBars();
    },
    computed: {
        filteredBars() {
            if (!this.search) {
                return this.bars;
            }

            const lowerCaseSearch = this.search.toLowerCase();

            return this.bars.filter(bar => {
                return Object.values(bar).some(val => {
                    if (val === null || val === undefined) {
                        return false;
                    }

                    const lowerCaseVal = typeof val === 'string' ? val.toLowerCase() : String(val);

                    return lowerCaseVal.includes(lowerCaseSearch);
                });
            });
        }
    }
    // Resto del código...
};
</script>

<style scoped>
.container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 80vh;
    /* Ajusta esto según tus necesidades */
    background-color: #f0f0f0;
    /* Color de fondo fuera de la tabla */
}

.table-wrapper {
    background-color: #fff;
    /* Color de fondo de la tabla */
    /* Añade más estilos para la tabla según tus necesidades */
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
    background-color: #4CAF50;
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
    background-color: #0cb6b9;
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
    background-color: #f44336;

}

.update {
    background-color: #2196f3;

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
    background: #ff1d5e;
    height: 100%;
    width: 100%;
    border-radius: 50%;
    animation: flower-spinner-smaller-dot-animation 2.5s 0s infinite both;

}

.flower-spinner .bigger-dot {
    background: #ff1d5e;
    height: 100%;
    width: 100%;
    padding: 10%;
    border-radius: 50%;
    animation: flower-spinner-bigger-dot-animation 2.5s 0s infinite both;
}

@keyframes flower-spinner-bigger-dot-animation {

    0%,
    100% {
        box-shadow: rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px;
    }

    50% {
        transform: rotate(180deg);
    }

    25%,
    75% {
        box-shadow: rgb(255, 29, 94) 26px 0px 0px,
            rgb(255, 29, 94) -26px 0px 0px,
            rgb(255, 29, 94) 0px 26px 0px,
            rgb(255, 29, 94) 0px -26px 0px,
            rgb(255, 29, 94) 19px -19px 0px,
            rgb(255, 29, 94) 19px 19px 0px,
            rgb(255, 29, 94) -19px -19px 0px,
            rgb(255, 29, 94) -19px 19px 0px;
    }

    100% {
        transform: rotate(360deg);
        box-shadow: rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px;
    }
}

@keyframes flower-spinner-smaller-dot-animation {

    0%,
    100% {
        box-shadow: rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px;
    }

    25%,
    75% {
        box-shadow: rgb(255, 29, 94) 14px 0px 0px,
            rgb(255, 29, 94) -14px 0px 0px,
            rgb(255, 29, 94) 0px 14px 0px,
            rgb(255, 29, 94) 0px -14px 0px,
            rgb(255, 29, 94) 10px -10px 0px,
            rgb(255, 29, 94) 10px 10px 0px,
            rgb(255, 29, 94) -10px -10px 0px,
            rgb(255, 29, 94) -10px 10px 0px;
    }

    100% {
        box-shadow: rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px,
            rgb(255, 29, 94) 0px 0px 0px;
    }
}
</style>