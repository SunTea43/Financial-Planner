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

  test "should destroy budget" do
    assert_difference("Budget.count", -1) do
      delete budget_url(@budget)
    end

    assert_redirected_to budgets_url
    follow_redirect!
    assert_response :success
  end
end
