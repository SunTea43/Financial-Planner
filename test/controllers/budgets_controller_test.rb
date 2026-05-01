require "test_helper"

class BudgetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @budget = budgets(:one)

    # Ensure budget has valid items
    @budget.budget_items.destroy_all
    @budget.budget_items.create!(item_type: "income", name: "Salary", amount: 1000)
    @budget.budget_items.create!(item_type: "expense", name: "Rent", amount: 500)
  end

  test "should get index" do
    get budgets_url
    assert_response :success
  end

  test "new loads category suggestions for current user" do
    @budget.budget_items.create!(item_type: "expense", name: "Gym", amount: 90, category: "Bienestar")

    get new_budget_url

    assert_response :success
    assert_includes assigns(:budget_categories), "Bienestar"
  end

  test "show prepares chart data and indicators" do
    @budget.budget_items.create!(item_type: "income", name: "Freelance", amount: 1200, category: "Servicios")
    @budget.budget_items.create!(item_type: "expense", name: "ETF", amount: 300, category: "Inversion")
    @budget.budget_items.create!(item_type: "expense", name: "Renta", amount: 500, category: "Renta")

    get budget_url(@budget)

    assert_response :success
    assert_not_nil assigns(:expense_category_chart_data)
    assert_not_nil assigns(:income_category_chart_data)
    assert_not_nil assigns(:budget_indicators)

    expense_data = assigns(:expense_category_chart_data)
    indicators = assigns(:budget_indicators)

    assert_includes expense_data[:labels], "Inversion"
    assert_includes expense_data[:labels], "Renta"
    assert_operator indicators[:expense_ratio], :>=, 0
  end

  test "should update budget removing and reordering items" do
    income_item = @budget.budget_items.create!(item_type: "income", name: "Bonus", amount: 200)
    expense_item = @budget.budget_items.create!(item_type: "expense", name: "Internet", amount: 80, position: 3)

    patch budget_url(@budget), params: {
      budget: {
        name: @budget.name,
        periodicity: @budget.periodicity,
        start_date: @budget.start_date,
        end_date: @budget.end_date,
        budget_items_attributes: {
          "0" => {
            id: income_item.id,
            _destroy: "1"
          },
          "1" => {
            id: expense_item.id,
            name: expense_item.name,
            item_type: expense_item.item_type,
            amount: expense_item.amount,
            category: "Servicios",
            description: expense_item.description,
            position: 1
          }
        }
      }
    }

    assert_redirected_to budget_path(@budget)
    assert_not BudgetItem.exists?(income_item.id)
    assert_equal 1, expense_item.reload.position
    assert_equal "Servicios", expense_item.category
  end

  test "should destroy budget" do
    assert_difference("Budget.count", -1) do
      delete budget_url(@budget)
    end

    assert_redirected_to budgets_url
    follow_redirect!
    assert_response :success
  end
end
