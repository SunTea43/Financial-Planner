import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static values = {
    data: Object
  }

  connect() {
    if (!this.dataValue || !this.dataValue.labels) return

    this.chart = new Chart(this.element, {
      type: "line",
      data: {
        labels: this.dataValue.labels,
        datasets: [
          {
            label: "Ahorro acumulado sin interes",
            data: this.dataValue.without_interest,
            borderColor: "#dc3545",
            backgroundColor: "rgba(220, 53, 69, 0.10)",
            tension: 0.3,
            fill: false
          },
          {
            label: "Ahorro acumulado con interes",
            data: this.dataValue.with_interest,
            borderColor: "#198754",
            backgroundColor: "rgba(25, 135, 84, 0.10)",
            tension: 0.3,
            fill: false
          },
          {
            label: "Meta",
            data: this.dataValue.goal,
            borderColor: "#0d6efd",
            borderDash: [6, 4],
            pointRadius: 0,
            fill: false
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "top"
          },
          title: {
            display: true,
            text: "Proyeccion de ahorro mensual"
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                let label = context.dataset.label || ""
                if (label) label += ": "
                label += new Intl.NumberFormat("es-MX", {
                  style: "currency",
                  currency: "MXN"
                }).format(context.raw)
                return label
              }
            }
          }
        },
        scales: {
          y: {
            ticks: {
              callback: function(value) {
                return "$" + Number(value).toLocaleString("es-MX")
              }
            }
          }
        }
      }
    })
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
    }
  }
}
