require "test_helper"

class BudgetsViewsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @budget = budgets(:one)

    @budget.budget_items.destroy_all
    @budget.budget_items.create!(item_type: "income", name: "Salary", amount: 3000, category: "Trabajo")
    @budget.budget_items.create!(item_type: "expense", name: "Rent", amount: 1200, category: "Renta")
    @budget.budget_items.create!(item_type: "expense", name: "ETF", amount: 400, category: "Inversion")
  end

  test "show renders indicators and category charts" do
    get budget_path(@budget)

    assert_response :success
    assert_select "#budget-indicators .card", minimum: 6
    assert_select "[data-controller='budget-category-chart']"
    assert_select "#budgetChartViewMode option[value='amount']", count: 1
    assert_select "#budgetChartViewMode option[value='percentage']", count: 1
    assert_select "#budgetExpenseCategoryChart"
    assert_select "#budgetIncomeCategoryChart"
  end

  test "new renders category datalist suggestions" do
    get new_budget_path

    assert_response :success
    assert_select "datalist#budget-category-options"
    assert_select "datalist#budget-category-options option[value='Trabajo']"
    assert_select "datalist#budget-category-options option[value='Renta']"
  end
end
