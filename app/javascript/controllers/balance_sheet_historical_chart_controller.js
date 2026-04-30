import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
    static values = {
        historicalData: Object
    }

    connect() {
        this.renderHistoricalChart()
    }

    renderHistoricalChart() {
        const ctx = document.getElementById('historicalLineChart')
        if (!ctx || !this.historicalDataValue) return

        const data = this.historicalDataValue
        
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.labels,
                datasets: [
                    {
                        label: 'Total Activos',
                        data: data.assetsData,
                        borderColor: '#28a745',
                        backgroundColor: 'rgba(40, 167, 69, 0.1)',
                        borderWidth: 2,
                        tension: 0.4,
                        fill: true,
                        pointRadius: 5,
                        pointBackgroundColor: '#28a745',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2
                    },
                    {
                        label: 'Total Pasivos',
                        data: data.liabilitiesData,
                        borderColor: '#dc3545',
                        backgroundColor: 'rgba(220, 53, 69, 0.1)',
                        borderWidth: 2,
                        tension: 0.4,
                        fill: true,
                        pointRadius: 5,
                        pointBackgroundColor: '#dc3545',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2
                    },
                    {
                        label: 'Patrimonio Neto',
                        data: data.netWorthData,
                        borderColor: '#007bff',
                        backgroundColor: 'rgba(0, 123, 255, 0.1)',
                        borderWidth: 2,
                        tension: 0.4,
                        fill: true,
                        pointRadius: 5,
                        pointBackgroundColor: '#007bff',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            font: {
                                size: 12
                            },
                            padding: 15,
                            usePointStyle: true
                        }
                    },
                    title: {
                        display: true,
                        text: 'Comportamiento Histórico: Activos, Pasivos y Patrimonio',
                        font: {
                            size: 16,
                            weight: 'bold'
                        },
                        padding: 20
                    },
                    tooltip: {
                        mode: 'index',
                        intersect: false,
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        padding: 12,
                        titleFont: {
                            size: 13
                        },
                        bodyFont: {
                            size: 12
                        },
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': $' + context.parsed.y.toLocaleString('es-ES', {
                                    minimumFractionDigits: 2,
                                    maximumFractionDigits: 2
                                })
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString('es-ES', {
                                    minimumFractionDigits: 0,
                                    maximumFractionDigits: 0
                                })
                            }
                        },
                        grid: {
                            drawBorder: false
                        }
                    },
                    x: {
                        grid: {
                            drawBorder: false,
                            display: false
                        }
                    }
                }
            }
        })
    }
}
