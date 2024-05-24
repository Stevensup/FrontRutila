<template>
    <div>
        <h2>Gráfico de Top Ventas Bebidas</h2>
        <div ref="chart" style="width: 700px; height: 700px;"></div>
    </div>
</template>

<script>
import axios from 'axios';
import * as echarts from 'echarts';

export default {
    mounted() {
        this.$nextTick(() => {
            this.fetchData();
        });
    },
    methods: {
        async fetchData() {
            try {
                const response = await axios.get('http://localhost:8090/topSelling/listar');
                const data = response.data;
                console.log(data);

                const chartData = data.map(item => ({
                    name: item.drink_name, // Cambiado de nombre_bebida a drink_name
                    value: item.total_orders // Cambiado de total_ordenes a total_orders
                }));

                this.renderChart(chartData);
            } catch (error) {
                console.error(error);
            }
        },
        renderChart(data) {
    const chart = echarts.init(this.$refs.chart);
    const options = {
        color: ['#003366', '#006699', '#4cabce', '#e5323e'],
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
#pie-chart {
    width: 400px;
    height: 400px;
}
</style>
