import { Application } from "@hotwired/stimulus"
import Chart from "chart.js/auto"
import ChartController from "./chart_controller"
import BudgetCategoryChartController from "./budget_category_chart_controller"

jest.mock("chart.js/auto", () => jest.fn())

const waitForStimulus = () => new Promise((resolve) => setTimeout(resolve, 0))

describe("chart controllers", () => {
  let application
  let chartInstances

  beforeEach(() => {
    chartInstances = []
    Chart.mockImplementation((element, config) => {
      const instance = {
        element,
        config,
        destroy: jest.fn()
      }

      chartInstances.push(instance)
      return instance
    })
  })

  afterEach(() => {
    if (application) {
      application.stop()
      application = null
    }

    document.body.innerHTML = ""
    jest.clearAllMocks()
  })

  test("renders and destroys the generic line chart", async () => {
    document.body.innerHTML = `
      <canvas
        data-controller="chart"
        data-chart-data-value='{"labels":["Jan"],"datasets":[{"label":"Balance","data":[1200]}]}'
      ></canvas>
    `

    application = Application.start()
    application.register("chart", ChartController)
    await waitForStimulus()

    expect(Chart).toHaveBeenCalledTimes(1)
    expect(chartInstances[0].element).toBe(document.querySelector("canvas"))
    expect(chartInstances[0].config.type).toBe("line")
    expect(chartInstances[0].config.data.labels).toEqual(["Jan"])

    document.querySelector("canvas").remove()
    await waitForStimulus()

    expect(chartInstances[0].destroy).toHaveBeenCalledTimes(1)
  })

  test("renders budget category charts and updates display mode", async () => {
    document.body.innerHTML = `
      <section
        data-controller="budget-category-chart"
        data-budget-category-chart-expense-data-value='{"labels":["Food","Rent"],"values":[100,200]}'
        data-budget-category-chart-income-data-value='{"labels":["Salary"],"values":[500]}'
        data-budget-category-chart-expense-title-value="Expense categories"
        data-budget-category-chart-income-title-value="Income categories"
        data-budget-category-chart-currency-value="COP"
        data-budget-category-chart-locale-value="es-CO"
      >
        <select data-action="change->budget-category-chart#toggleViewMode">
          <option value="amount" selected>Amount</option>
          <option value="percentage">Percentage</option>
        </select>
        <canvas id="budgetExpenseCategoryChart"></canvas>
        <canvas id="budgetIncomeCategoryChart"></canvas>
      </section>
    `

    application = Application.start()
    application.register("budget-category-chart", BudgetCategoryChartController)
    await waitForStimulus()

    expect(Chart).toHaveBeenCalledTimes(2)
    expect(chartInstances[0].element).toBe(document.getElementById("budgetExpenseCategoryChart"))
    expect(chartInstances[0].config.type).toBe("doughnut")
    expect(chartInstances[0].config.data.datasets[0].data).toEqual([100, 200])
    expect(chartInstances[1].element).toBe(document.getElementById("budgetIncomeCategoryChart"))

    const select = document.querySelector("select")
    select.value = "percentage"
    select.dispatchEvent(new Event("change", { bubbles: true }))
    await waitForStimulus()

    expect(Chart).toHaveBeenCalledTimes(4)
    expect(chartInstances[0].destroy).toHaveBeenCalledTimes(1)
    expect(chartInstances[1].destroy).toHaveBeenCalledTimes(1)
    expect(chartInstances[2].config.data.datasets[0].data[0]).toBeCloseTo(33.333)
    expect(chartInstances[2].config.data.datasets[0].data[1]).toBeCloseTo(66.667)
    expect(chartInstances[3].config.data.datasets[0].data).toEqual([100])
  })
})
