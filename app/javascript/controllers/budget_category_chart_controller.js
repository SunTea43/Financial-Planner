import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static values = {
    expenseData: Object,
    incomeData: Object,
    expenseTitle: String,
    incomeTitle: String,
    currency: String,
    locale: String,
    viewMode: { type: String, default: "amount" }
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
    this.renderExpenseChart()
    this.renderIncomeChart()
  }

  renderExpenseChart() {
    const ctx = document.getElementById("budgetExpenseCategoryChart")
    if (!ctx || !this.expenseDataValue || this.expenseDataValue.labels.length === 0) return

    const data = this.chartDataFor(this.expenseDataValue)
    const chart = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: data.labels,
        datasets: [
          {
            data: data.displayValues,
            backgroundColor: ["#dc3545", "#fd7e14", "#ffc107", "#20c997", "#0dcaf0", "#6f42c1", "#6c757d"],
            borderWidth: 2
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          title: {
            display: true,
            text: this.expenseTitleValue
          },
          legend: {
            position: "bottom",
            labels: {
              generateLabels: (chart) => this.generateLegendLabels(chart, data)
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

  renderIncomeChart() {
    const ctx = document.getElementById("budgetIncomeCategoryChart")
    if (!ctx || !this.incomeDataValue || this.incomeDataValue.labels.length === 0) return

    const data = this.chartDataFor(this.incomeDataValue)
    const chart = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: data.labels,
        datasets: [
          {
            data: data.displayValues,
            backgroundColor: ["#198754", "#20c997", "#0dcaf0", "#0d6efd", "#6f42c1", "#adb5bd"],
            borderWidth: 2
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          title: {
            display: true,
            text: this.incomeTitleValue
          },
          legend: {
            position: "bottom",
            labels: {
              generateLabels: (chart) => this.generateLegendLabels(chart, data)
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
    const percentages = values.map((value) => (total > 0 ? (value / total) * 100 : 0))

    return {
      labels: source.labels || [],
      values,
      percentages,
      total,
      displayValues: this.viewModeValue === "percentage" ? percentages : values
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
    return this.viewModeValue === "percentage" ? this.formatPercentage(data.percentages[index]) : this.formatCurrency(data.values[index])
  }

  secondaryValueFor(data, index) {
    return this.viewModeValue === "percentage" ? this.formatCurrency(data.values[index]) : this.formatPercentage(data.percentages[index])
  }

  formatCurrency(value) {
    const locale = this.localeValue || "es"
    const currency = this.currencyValue || "COP"

    return new Intl.NumberFormat(locale, { style: "currency", currency }).format(value || 0)
  }

  formatPercentage(value) {
    const locale = this.localeValue || "es"

    return new Intl.NumberFormat(locale, {
      style: "percent",
      minimumFractionDigits: 1,
      maximumFractionDigits: 1
    }).format((value || 0) / 100)
  }
}
