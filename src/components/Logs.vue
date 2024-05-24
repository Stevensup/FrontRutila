<template>
    <div>
        <br>
        <br>
        <table class="my-table">
            <thead>
                <tr>
                    <th>
                        ID
                        <input type="text" v-model="filters.id" placeholder="Filtrar ID...">
                    </th>
                    <th>
                        Tables
                        <input type="text" v-model="filters.tables" placeholder="Filtrar Tables...">
                    </th>
                    <th>
                        Operation
                        <input type="text" v-model="filters.operation" placeholder="Filtrar Operation...">
                    </th>
                    <th>
                        Users
                        <input type="text" v-model="filters.users" placeholder="Filtrar Users...">
                    </th>
                    <th>
                        Detail
                        <input type="text" v-model="filters.detail" placeholder="Filtrar Detail...">
                    </th>
                    <th>
                        Date
                        <input type="text" v-model="filters.dates" placeholder="Filtrar Date...">
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="log in filteredLogs" :key="log.id">
                    <td>{{ log.id }}</td>
                    <td>{{ log.tables }}</td>
                    <td>{{ log.operation }}</td>
                    <td>{{ log.users }}</td>
                    <td>{{ log.detail }}</td>
                    <td>{{ log.dates }}</td>
                </tr>
            </tbody>
        </table>
        <button @click="page--" :disabled="page === 1">Anterior</button>
        <button @click="page++" :disabled="page === maxPage">Siguiente</button>
    </div>
</template>

<script>
import axios from 'axios';
export default {
    name: 'MyLogs',
    data() {
        return {
            search: '',
            logs: [],
            page: 1,
            perPage: 10,
            filters: {
                id: '',
                tables: '',
                operation: '',
                users: '',
                detail: '',
                dates: ''
            }
        };
    },
    computed: {
        filteredLogs() {
            return this.logs
                .filter(log => Object.keys(this.filters).every(key => String(log[key]).includes(this.filters[key])))
                .slice((this.page - 1) * this.perPage, this.page * this.perPage);
        },
        maxPage() {
            return Math.ceil(this.logs.length / this.perPage);
        }
    },
    mounted() {
        this.fetchLogs();
    },
    methods: {
        fetchLogs() {
            axios.get('http://localhost:8090/logs/listar')
                .then(response => {
                    this.logs = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        }
    }
};
</script>

<style>
/* Estilos CSS para la tabla */
.my-table {
    width: 80%; /* Hacer la tabla un poco más pequeña */
    margin: auto; /* Centrar la tabla */
    border-collapse: collapse;
}

.my-table th, .my-table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

.my-table th {
    background-color: #f2f2f2;
}
</style>