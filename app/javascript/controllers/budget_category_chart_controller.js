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

    const data = buildChartDisplayData(this.expenseDataValue, this.viewModeValue)
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
              generateLabels: (chart) => generateLegendLabels(chart, data, (chartData, index) => this.primaryValueFor(chartData, index))
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

  renderIncomeChart() {
    const ctx = document.getElementById("budgetIncomeCategoryChart")
    if (!ctx || !this.incomeDataValue || this.incomeDataValue.labels.length === 0) return

    const data = buildChartDisplayData(this.incomeDataValue, this.viewModeValue)
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
              generateLabels: (chart) => generateLegendLabels(chart, data, (chartData, index) => this.primaryValueFor(chartData, index))
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
    const locale = this.localeValue || "es"
    const currency = this.currencyValue || "COP"

    return formatCurrency(locale, currency, value)
  }

  formatPercentage(value) {
    const locale = this.localeValue || "es"

    return formatPercentage(locale, value)
  }
}
