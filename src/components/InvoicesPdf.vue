<template>
    <div>
      <h1>Invoices to PDF</h1>
      <form @submit.prevent="fetchInvoice">
        <label for="invoiceId">Ingrese el ID:</label>
        <input v-model="invoiceId" id="invoiceId" type="text">
        <button type="submit">Buscar</button>
      </form>
      <div v-if="invoice">
        <h2># of invoice: {{ invoice.invoiceNumber }}</h2>
        <p>Client: {{ invoice.customerName }}</p>
        <p>quantity: {{ invoice.quantity }}</p>
        <p>Drink: {{ invoice.drinkName }}</p>
        <p>Price de la bebida: {{ invoice.drinkPrice }}</p>
        <p>Pub: {{ invoice.pubName }}</p>
        <p>Seller: {{ invoice.sellerName }}</p>
        <p>Total: {{ invoice.totalPrice }}</p>
        <p>Date invoice: {{ invoice.invoiceDate }}</p>
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