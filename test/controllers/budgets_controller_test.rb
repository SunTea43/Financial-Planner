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

  test "should get new with clone_id" do
    get new_budget_url(clone_id: @budget.id)
    assert_response :success

    # Verify the copied name is present in the response
    assert_select "input[value=?]", "#{@budget.name} (Copia)"

    # Verify the budget items were copied
    assert_select "input[value=?]", "Salary"
    assert_select "input[value=?]", "Rent"
  end
end
