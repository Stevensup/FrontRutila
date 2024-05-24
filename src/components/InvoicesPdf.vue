<template>
    <div>
      <h1>Factura PDF</h1>
      <form @submit.prevent="fetchInvoice">
        <label for="invoiceId">Ingrese el ID:</label>
        <input v-model="invoiceId" id="invoiceId" type="text">
        <button type="submit">Buscar</button>
      </form>
      <div v-if="invoice">
        <h2>Número de factura: {{ invoice.invoiceNumber }}</h2>
        <p>Cliente: {{ invoice.customerName }}</p>
        <p>Cantidad: {{ invoice.quantity }}</p>
        <p>Bebida: {{ invoice.drinkName }}</p>
        <p>Precio de la bebida: {{ invoice.drinkPrice }}</p>
        <p>Pub: {{ invoice.pubName }}</p>
        <p>Vendedor: {{ invoice.sellerName }}</p>
        <p>Total: {{ invoice.totalPrice }}</p>
        <p>Fecha de la factura: {{ invoice.invoiceDate }}</p>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    name: 'FacturaPDF',
    data() {
      return {
        invoice: null,
        invoiceId: '',
      };
    },
    methods: {
      async fetchInvoice() {
        const response = await axios.get(`http://localhost:8090/invoiceView/id/${this.invoiceId}`);
        this.invoice = response.data;
      },
    },
  };
  </script>