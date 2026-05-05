import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

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

        const data = this.chartDataFor(this.assetsDataValue)

        const chart = new Chart(assetsCtx, {
            type: 'pie',
            data: {
                labels: data.labels,
                datasets: [{
                    data: data.displayValues,
                    rawValues: data.values,
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
                            generateLabels: (chartInstance) => this.generateLegendLabels(chartInstance, data)
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
                            label: (context) => this.tooltipLabel(context, data)
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

        const data = this.chartDataFor(this.liabilitiesDataValue)

        const chart = new Chart(liabilitiesCtx, {
            type: 'pie',
            data: {
                labels: data.labels,
                datasets: [{
                    data: data.displayValues,
                    rawValues: data.values,
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
                            generateLabels: (chartInstance) => this.generateLegendLabels(chartInstance, data)
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
                            label: (context) => this.tooltipLabel(context, data)
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

    chartDataFor(source) {
        const values = source.values || []
        const total = values.reduce((sum, value) => sum + value, 0)
        const percentages = values.map((value) => total > 0 ? (value / total) * 100 : 0)

        return {
            labels: source.labels || [],
            values,
            percentages,
            total,
            displayValues: this.viewModeValue === 'percentage' ? percentages : values
        }
    }

    generateLegendLabels(chart, data) {
        const dataset = chart.data.datasets[0]

        return data.labels.map((label, index) => {
            const backgroundColor = Array.isArray(dataset.backgroundColor) ? dataset.backgroundColor[index] : dataset.backgroundColor

            return {
                text: `${label}: ${this.primaryValueFor(data, index)}`,
                fillStyle: backgroundColor,
                strokeStyle: backgroundColor,
                lineWidth: dataset.borderWidth || 0,
                hidden: !chart.getDataVisibility(index),
                index
            }
        })
    }

    tooltipLabel(context, data) {
        const index = context.dataIndex
        const primaryValue = this.primaryValueFor(data, index)
        const secondaryValue = this.secondaryValueFor(data, index)

        return `${context.label}: ${primaryValue} (${secondaryValue})`
    }

    primaryValueFor(data, index) {
        return this.viewModeValue === 'percentage' ? this.formatPercentage(data.percentages[index]) : this.formatCurrency(data.values[index])
    }

    secondaryValueFor(data, index) {
        return this.viewModeValue === 'percentage' ? this.formatCurrency(data.values[index]) : this.formatPercentage(data.percentages[index])
    }

    formatCurrency(value) {
        const locale = this.localeValue || 'es'
        const currency = this.currencyValue || 'COP'

        return new Intl.NumberFormat(locale, {
            style: 'currency',
            currency
        }).format(value || 0)
    }

    formatPercentage(value) {
        const locale = this.localeValue || 'es'

        return new Intl.NumberFormat(locale, {
            style: 'percent',
            minimumFractionDigits: 1,
            maximumFractionDigits: 1
        }).format((value || 0) / 100)
    }
}
