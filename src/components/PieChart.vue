<template>
    <div>
        <h1>Gráficos</h1>
        <br>
        <br>
        <br>
        <br>
        <br>
        <div class="chart-container">
            <h3>Top 5 Bebidas más vendidas</h3>
            <div ref="chart1" class="chart"></div>
            <h3>Top 5 Pubs con más ingresos</h3>
            <div ref="chart2" class="chart"></div>
            <h3>Top 5 Clientes más frecuentes</h3>
            <div ref="chart3" class="chart"></div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import * as echarts from 'echarts';

export default {
    mounted() {
        this.$nextTick(() => {
            this.fetchData1();
            this.fetchData2();
            this.fetchData3();
        });
    },
    methods: {
        async fetchData1() {
            try {
                const response = await axios.get('http://localhost:8090/topSelling/listar');
                const data = response.data;
                const chartData = data.map(item => ({ name: item.drink_name, value: item.total_orders }));
                this.renderChart(this.$refs.chart1, chartData, ['#003366', '#006699', '#4cabce', '#e5323e']);
            } catch (error) {
                console.error(error);
            }
        },
        async fetchData2() {
            try {
                const response = await axios.get('http://localhost:8090/pubRevenue/listar');
                const data = response.data;
                const chartData = data.map(item => ({ name: item.name, value: item.total_revenue }));
                this.renderChart(this.$refs.chart2, chartData, ['#339966', '#66cc99', '#99ccff', '#cc99ff']);
            } catch (error) {
                console.error(error);
            }
        },
        async fetchData3() {
            try {
                const response = await axios.get('http://localhost:8090/frecuentCustomers/listar');
                const data = response.data;
                const chartData = data.map(item => ({ name: item.name, value: item.total_orders }));
                this.renderChart(this.$refs.chart3, chartData, ['#ff9999', '#ffcc99', '#ffff99', '#ccff99']);
            } catch (error) {
                console.error(error);
            }
        },
        renderChart(chartRef, data, colors) {
            const chart = echarts.init(chartRef);
            const options = {
                color: colors,
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b} : {c} ({d}%)'
                },
                series: [
                    {
                        name: 'Pedidos',
                        type: 'pie',
                        radius: '80%',
                        data: data,
                        label: {
                            show: true,
                            formatter: '{b}'
                        }
                    }
                ]
            };
            chart.setOption(options);
        }
    }
};
</script>
<style>
.chart-container {
    display: flex;
    justify-content: space-around;
}

.chart {
    width: 400px;
    height: 400px;
}

h3 {
    text-align: center;
    color: #F28A2E;
}
</style>