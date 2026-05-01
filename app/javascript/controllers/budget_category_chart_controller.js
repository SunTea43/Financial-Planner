import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static values = {
    expenseData: Object,
    incomeData: Object
  }

  connect() {
    this.charts = []
    this.renderExpenseChart()
    this.renderIncomeChart()
  }

  renderExpenseChart() {
    const ctx = document.getElementById("budgetExpenseCategoryChart")
    if (!ctx || !this.expenseDataValue || this.expenseDataValue.labels.length === 0) return

    const chart = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: this.expenseDataValue.labels,
        datasets: [
          {
            data: this.expenseDataValue.values,
            backgroundColor: ["#dc3545", "#fd7e14", "#ffc107", "#20c997", "#0dcaf0", "#6f42c1", "#6c757d"],
            borderWidth: 2
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "bottom"
          },
          title: {
            display: true,
            text: "Distribucion de gastos por categoria"
          },
          tooltip: {
            callbacks: {
              label(context) {
                const value = context.raw || 0
                return `${context.label}: ${new Intl.NumberFormat("es-MX", { style: "currency", currency: "MXN" }).format(value)}`
              }
            }
          }
        }
      }
    })

    this.charts.push(chart)
  }

  renderIncomeChart() {
    const ctx = document.getElementById("budgetIncomeCategoryChart")
    if (!ctx || !this.incomeDataValue || this.incomeDataValue.labels.length === 0) return

    const chart = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: this.incomeDataValue.labels,
        datasets: [
          {
            data: this.incomeDataValue.values,
            backgroundColor: ["#198754", "#20c997", "#0dcaf0", "#0d6efd", "#6f42c1", "#adb5bd"],
            borderWidth: 2
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "bottom"
          },
          title: {
            display: true,
            text: "Distribucion de ingresos por categoria"
          },
          tooltip: {
            callbacks: {
              label(context) {
                const value = context.raw || 0
                return `${context.label}: ${new Intl.NumberFormat("es-MX", { style: "currency", currency: "MXN" }).format(value)}`
              }
            }
          }
        }
      }
    })

    this.charts.push(chart)
  }

  disconnect() {
    this.charts.forEach((chart) => chart.destroy())
  }
}
