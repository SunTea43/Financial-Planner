import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
    static values = {
        data: Object
    }

    connect() {
        this.chart = new Chart(this.element, {
            type: "line",
            data: this.dataValue,
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: 'Historial del Valor del Activo'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value, index, values) {
                                return '$' + value;
                            }
                        }
                    }
                }
            }
        });

        // Make sure we destroy the chart when disconnecting to avoid memory leaks
        // or issues with Turbo
    }

    disconnect() {
        if (this.chart) {
            this.chart.destroy()
        }
    }
}
