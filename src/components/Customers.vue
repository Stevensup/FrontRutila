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
            <input type="text" v-model="search" placeholder="Buscar...">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Location</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="customer in customers" :key="`${customer.id}-${customer.name}`">
                        <td>{{ customer.id }}</td>
                        <td>{{ customer.name }}</td>
                        <td>{{ customer.location }}</td>
                        <td>{{ customer.phone }}</td>
                        <td>{{ customer.email }}</td>

                        <td>
                            <button class="delete" @click="deleteBar(customer.id)">Eliminar</button>
                            <button class="update"
                                @click="selectedBar = customer; showUpdateModal = true">Actualizar</button>
                            <!-- <button class="updatePassword" @click="updatePassword(customer.id) = customer; showUpdatePasswordModal = true">Actualizar Contraseña</button> -->
                        </td>
                    </tr>
                </tbody>
            </table>
            <div>
                <button @click="showModal = true">Agregar un Cliente</button>
            </div>
            <div v-if="showModal" class="modal">
                <div class="modal-content">
                    <span class="close" @click="showModal = false">&times;</span>
                    <form @submit.prevent="addCustomer">
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
export default {
    name: 'my-customers',
    data() {
        return {
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
            customers: []
        }
    },
    mounted() {
        this.fetchCustomers();
    },
    methods: {
        fetchCustomers() {
            fetch('http://localhost:8090/client/listar')
                .then(response => response.json())
                .then(data => {
                    this.customers = data;
                })
                .catch(error => {
                    console.error('Error fetching customers:', error);
                });
        },
        addCustomer() {
            fetch('http://localhost:8090/client/crear', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.newCustomer)
            })
                .then(response => response.json())
                .then(data => {
                    this.customers.push(data);
                    this.newCustomer = {
                        name: '',
                        location: '',
                        phone: '',
                        email: ''
                    };
                    this.showModal = false;
                })
                .catch(error => {
                    console.error('Error adding customer:', error);
                });
        },
        updateCustomer() {
            fetch(`http://localhost:8090/client/actualizar/${this.selectedCustomer.id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.selectedCustomer)
            })
                .then(response => response.json())
                .then(data => {
                    const index = this.customers.findIndex(customer => customer.id === data.id);
                    this.customers.splice(index, 1, data);
                    this.selectedCustomer = {
                        name: '',
                        location: '',
                        phone: '',
                        email: ''
                    };
                    this.showUpdateModal = false;
                })
                .catch(error => {
                    console.error('Error updating customer:', error);
                });
        },
        deleteCustomer(id) {
            fetch(`http://localhost:8090/client/eliminar/${id}`, {
                method: 'DELETE'
            })
                .then(() => {
                    this.customers = this.customers.filter(customer => customer.id !== id);
                })
                .catch(error => {
                    console.error('Error deleting customer:', error);
                });
        },
        // updatePassword(id) {
        //     fetch(`http://localhost:8090/client/actualizar/${this.selectedCustomer.id}`, {
        //         method: 'PUT',
        //         headers: {
        //             'Content-Type': 'application/json'
        //         },
        //         body: JSON.stringify(this.selectedCustomer)
        //     })
        //         .then(response => response.json())
        //         .then(data => {
        //             const index = this.customers.findIndex(customer => customer.id === data.id);
        //             this.customers.splice(index, 1, data);
        //             this.selectedCustomer = {
        //                 name: '',
        //                 location: '',
        //                 phone: '',
        //                 email: ''
        //             };
        //             this.showUpdatePasswordModal = false;
        //         })
        //         .catch(error => {
        //             console.error('Error updating customer:', error);
        //         });
        // }

    },
    computed: {
        filteredCustomers() {
            return this.customers.filter(customer => {
                return customer.name.toLowerCase().includes(this.search.toLowerCase());
            });
        }
    }
}
</script>

<style scoped>
.container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
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