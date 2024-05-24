<template>
    <div>
      <h1>Invoices to PDF</h1>
      <form @submit.prevent="fetchInvoice">
        <label for="invoiceId">Ingrese el ID:</label>
        <input v-model="invoiceId" id="invoiceId" type="text">
        <button type="submit">Buscar</button>
      </form>
      <div v-if="invoice" class="invoice">
        <h2># of invoice: {{ invoice.invoiceNumber }}</h2>
        <p>Client: {{ invoice.customerName }}</p>
        <p>quantity: {{ invoice.quantity }}</p>
        <p>Drink: {{ invoice.drinkName }}</p>
        <p>Price de la bebida: {{ invoice.drinkPrice }}</p>
        <p>Pub: {{ invoice.pubName }}</p>
        <p>Seller: {{ invoice.sellerName }}</p>
        <p>Total: {{ invoice.totalPrice }}</p>
        <p>Date invoice: {{ invoice.invoiceDate }}</p>
        <button @click="exportToPdf">Exportar a PDF</button>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  import jsPDF from 'jspdf';

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
      exportToPdf() {
      const doc = new jsPDF();
      doc.text('Invoice Number: ' + this.invoice.invoiceNumber, 10, 10);
      doc.text('Client: ' + this.invoice.customerName, 10, 20);
      doc.text('Quantity: ' + this.invoice.quantity, 10, 30);
      doc.text('Drink: ' + this.invoice.drinkName, 10, 40);
      doc.text('Drink Price: ' + this.invoice.drinkPrice, 10, 50);
      doc.text('Pub: ' + this.invoice.pubName, 10, 60);
      doc.text('Seller: ' + this.invoice.sellerName, 10, 70);
      doc.text('Total: ' + this.invoice.totalPrice, 10, 80);
      doc.text('Invoice Date: ' + this.invoice.invoiceDate, 10, 90);
      doc.save('invoice.pdf');
    },
    },
  };
  </script>
  
  <style scoped>
  .invoice {
    border: 1px solid #000;
    padding: 20px;
    margin: 20px 0;
  }
  
  .invoice h2 {
    margin-top: 0;
  }
  
  .invoice p {
    margin: 5px 0;
  }
  
  .invoice button {
    display: block;
    margin-top: 20px;
    padding: 10px 20px;
    background-color: #007BFF;
    color: #fff;
    border: none;
    cursor: pointer;
  }
  
  .invoice button:hover {
    background-color: #0056b3;
  }
  </style>