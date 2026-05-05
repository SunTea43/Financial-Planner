import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"
import {
    buildChartDisplayData,
    formatCurrency,
    formatPercentage,
    generateLegendLabels,
    primaryValueFor,
    secondaryValueFor,
    tooltipLabel
} from "./pie_chart_view_helpers"

export default class extends Controller {
    static values = {
        assetsData: Object,
        liabilitiesData: Object,
        assetsTitle: String,
        liabilitiesTitle: String,
        currency: String,
        locale: String,
        viewMode: { type: String, default: 'amount' }
    }

    connect() {
        this.charts = []
        this.renderCharts()
    }

    toggleViewMode(event) {
        this.viewModeValue = event.target.value
        this.renderCharts()
    }

    renderCharts() {
        this.destroyCharts()
        this.renderAssetsChart()
        this.renderLiabilitiesChart()
    }

    renderAssetsChart() {
        const assetsCtx = document.getElementById('assetsPieChart')
        if (!assetsCtx || !this.assetsDataValue) return

        const data = buildChartDisplayData(this.assetsDataValue, this.viewModeValue)

        const chart = new Chart(assetsCtx, {
            type: 'pie',
            data: {
                labels: data.labels,
                datasets: [{
                    data: data.displayValues,
                    backgroundColor: [
                        '#28a745', // green
                        '#20c997', // teal
                        '#17a2b8', // cyan
                        '#007bff', // blue
                        '#6c757d', // gray
                        '#ffc107', // yellow
                        '#fd7e14', // orange
                        '#dc3545'  // red
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            generateLabels: (chartInstance) => generateLegendLabels(chartInstance, data, (chartData, index) => this.primaryValueFor(chartData, index))
                        }
                    },
                    title: {
                        display: true,
                        text: this.assetsTitleValue,
                        font: {
                            size: 16
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: (context) => tooltipLabel(context, data, (chartData, index) => this.primaryValueFor(chartData, index), (chartData, index) => this.secondaryValueFor(chartData, index))
                        }
                    }
                }
            }
        })

        this.charts.push(chart)
    }

    renderLiabilitiesChart() {
        const liabilitiesCtx = document.getElementById('liabilitiesPieChart')
        if (!liabilitiesCtx || !this.liabilitiesDataValue) return

        const data = buildChartDisplayData(this.liabilitiesDataValue, this.viewModeValue)

        const chart = new Chart(liabilitiesCtx, {
            type: 'pie',
            data: {
                labels: data.labels,
                datasets: [{
                    data: data.displayValues,
                    backgroundColor: [
                        '#dc3545', // red
                        '#fd7e14', // orange
                        '#ffc107', // yellow
                        '#6c757d', // gray
                        '#17a2b8', // cyan
                        '#007bff'  // blue
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            generateLabels: (chartInstance) => generateLegendLabels(chartInstance, data, (chartData, index) => this.primaryValueFor(chartData, index))
                        }
                    },
                    title: {
                        display: true,
                        text: this.liabilitiesTitleValue,
                        font: {
                            size: 16
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: (context) => tooltipLabel(context, data, (chartData, index) => this.primaryValueFor(chartData, index), (chartData, index) => this.secondaryValueFor(chartData, index))
                        }
                    }
                }
            }
        })

        this.charts.push(chart)
    }

    disconnect() {
        this.destroyCharts()
    }

    destroyCharts() {
        this.charts.forEach((chart) => chart.destroy())
        this.charts = []
    }

    primaryValueFor(data, index) {
        return primaryValueFor(this.viewModeValue, data, index, (value) => this.formatCurrency(value), (value) => this.formatPercentage(value))
    }

    secondaryValueFor(data, index) {
        return secondaryValueFor(this.viewModeValue, data, index, (value) => this.formatCurrency(value), (value) => this.formatPercentage(value))
    }

    formatCurrency(value) {
        const locale = this.localeValue || 'es'
        const currency = this.currencyValue || 'COP'

        return formatCurrency(locale, currency, value)
    }

    formatPercentage(value) {
        const locale = this.localeValue || 'es'

        return formatPercentage(locale, value)
    }
}
