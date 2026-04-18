import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
    static values = {
        assetsData: Object,
        liabilitiesData: Object
    }

    connect() {
        this.renderAssetsChart()
        this.renderLiabilitiesChart()
    }

    renderAssetsChart() {
        const assetsCtx = document.getElementById('assetsPieChart')
        if (!assetsCtx || !this.assetsDataValue) return

        new Chart(assetsCtx, {
            type: 'pie',
            data: {
                labels: this.assetsDataValue.labels,
                datasets: [{
                    data: this.assetsDataValue.values,
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
                    },
                    title: {
                        display: true,
                        text: 'Distribución de Activos por Categoría',
                        font: {
                            size: 16
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.label || ''
                                if (label) {
                                    label += ': '
                                }
                                const value = context.raw
                                label += new Intl.NumberFormat('es-MX', {
                                    style: 'currency',
                                    currency: 'MXN'
                                }).format(value)
                                return label
                            }
                        }
                    }
                }
            }
        })
    }

    renderLiabilitiesChart() {
        const liabilitiesCtx = document.getElementById('liabilitiesPieChart')
        if (!liabilitiesCtx || !this.liabilitiesDataValue) return

        new Chart(liabilitiesCtx, {
            type: 'pie',
            data: {
                labels: this.liabilitiesDataValue.labels,
                datasets: [{
                    data: this.liabilitiesDataValue.values,
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
                    },
                    title: {
                        display: true,
                        text: 'Distribución de Pasivos por Tipo',
                        font: {
                            size: 16
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.label || ''
                                if (label) {
                                    label += ': '
                                }
                                const value = context.raw
                                label += new Intl.NumberFormat('es-MX', {
                                    style: 'currency',
                                    currency: 'MXN'
                                }).format(value)
                                return label
                            }
                        }
                    }
                }
            }
        })
    }

    disconnect() {
        // Charts will be automatically destroyed when the element is removed
    }
}
