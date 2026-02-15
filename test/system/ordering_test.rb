require "application_system_test_case"

class OrderingTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "reordering assets in balance sheet" do
    balance_sheet = balance_sheets(:one)

    # Create assets for this balance sheet
    asset1 = Asset.create!(balance_sheet: balance_sheet, name: "Asset I", amount: 100, asset_type: "liquid", position: 1)
    asset2 = Asset.create!(balance_sheet: balance_sheet, name: "Asset II", amount: 200, asset_type: "liquid", position: 2)

    visit edit_balance_sheet_path(balance_sheet)

    # Use JS to swap position values as drag & drop is tricky
    page.execute_script("
      let inputs = document.querySelectorAll('#assets input[name*=\"[position]\"]');
      if (inputs.length >= 2) {
        inputs[0].value = '2';
        inputs[1].value = '1';
      }
    ")

    click_on "Actualizar Balance General"

    assert_text "Balance general actualizado exitosamente"

    assert_equal 2, asset1.reload.position
    assert_equal 1, asset2.reload.position
  end

  test "reordering budget items" do
    budget = budgets(:one)

    # Create items for this budget
    item1 = BudgetItem.create!(budget: budget, name: "Item I", amount: 100, item_type: "income", position: 1)
    item2 = BudgetItem.create!(budget: budget, name: "Item II", amount: 200, item_type: "income", position: 2)
    # Create an expense item so the controller doesn't build an empty one
    BudgetItem.create!(budget: budget, name: "Expense I", amount: 50, item_type: "expense", position: 1)

    visit edit_budget_path(budget)

    # Use JS to swap position values
    page.execute_script("
      let inputs = document.querySelectorAll('#income-items input[name*=\"[position]\"]');
      if (inputs.length >= 2) {
        inputs[0].value = '2';
        inputs[1].value = '1';
      }
    ")

    click_on "Actualizar Presupuesto"

    assert_text "Presupuesto actualizado exitosamente"

    assert_equal 2, item1.reload.position
    assert_equal 1, item2.reload.position
  end
end
