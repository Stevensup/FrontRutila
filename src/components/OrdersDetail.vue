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
          <img width="80" height="80" src="../assets/ICONOBAR.png" alt="Imagen">
        </div>
        <input class="search-input" type="text" v-model="search" placeholder="Buscar...">
        <table>
          <thead>
            <tr>
              <th>ID</th>
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
              <td>{{ detail.amount }}</td>
              <td>{{ detail.id_drink }}</td>
              <td>{{ detail.id_order }}</td>
              <td>
                <button class="update" @click="selectedDetail = detail; showUpdateModal = true">Actualizar</button>
              </td>
            </tr>
          </tbody>
        </table>
  
        <div class="pagination">
          <button @click="prevPage">Página anterior</button>
          <span>Página {{ currentPage }} de {{ totalPages }}</span>
          <button @click="nextPage">Página siguiente</button>
        </div>
  
        <button class="add" @click="showModal = true">Agregar Detalle de Orden</button>
  
        <!-- Add Detail Modal -->
        <div v-if="showModal" class="modal">
          <div class="modal-content">
            <span @click="showModal = false" class="close">&times;</span>
            <form @submit.prevent="saveDetail" class="form">
              <label for="customerName">Nombre del Cliente:</label>
              <input type="text" id="customerName" v-model="detail.customerName" required>
  
              <label for="productName">Producto:</label>
              <input type="text" id="productName" v-model="detail.productName" required>
  
              <label for="quantity">Cantidad:</label>
              <input type="number" id="quantity" v-model="detail.quantity" required>
  
              <label for="price">Precio:</label>
              <input type="number" id="price" v-model="detail.price" required>
  
              <button type="submit">Agregar Detalle</button>
            </form>
          </div>
        </div>
  
        <!-- Update Detail Modal -->
        <div v-if="showUpdateModal" class="modal">
          <div class="modal-content">
            <span @click="showUpdateModal = false" class="close">&times;</span>
            <form @submit.prevent="updateDetail">
              <label for="customerName">Nombre del Cliente:</label>
              <input type="text" id="customerName" v-model="selectedDetail.customerName" required>
  
              <label for="productName">Producto:</label>
              <input type="text" id="productName" v-model="selectedDetail.productName" required>
  
              <label for="quantity">Cantidad:</label>
              <input type="number" id="quantity" v-model="selectedDetail.quantity" required>
  
              <label for="price">Precio:</label>
              <input type="number" id="price" v-model="selectedDetail.price" required>
  
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
        currentPage: 1,
        itemsPerPage: 5,
        isLoading: false,
        showModal: false,
        showUpdateModal: false,
        selectedDetail: {
          id: '',
          customerName: '',
          productName: '',
          quantity: '',
          price: ''
        },
        search: '',
        detail: {
          customerName: '',
          productName: '',
          quantity: '',
          price: ''
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
      fetchDetails() {
        axios.get('http://localhost:8090/detailsOrder/listar')
          .then(response => { this.details = response.data; })
          .catch(error => { console.error(error); });
      },
      saveDetail() {
        axios.post('http://localhost:8090/detailsOrder/registrar', this.detail)
          .then(response => {
            console.log(response.data);
            this.fetchDetails();
            this.detail = {
              customerName: '',
              productName: '',
              quantity: '',
              price: ''
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
  
  .add, .delete, .update {
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
  
  .close:hover, .close:focus {
    color: black;
    text-decoration: none;
  }
  
  .form {
    display: flex;
    flex-direction: column;
  }
  
  .form label, .form input {
    margin-bottom: 10px;
  }
  </style>
  