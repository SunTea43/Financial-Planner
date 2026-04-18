require "test_helper"

class BalanceSheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @account = accounts(:one)
    @balance_sheet = balance_sheets(:one)
  end

  test "should get report" do
    get report_balance_sheet_path(@balance_sheet)
    assert_response :success
  end

  test "report action prepares assets chart data" do
    get report_balance_sheet_path(@balance_sheet)
    assert_not_nil assigns(:assets_chart_data)
    assert assigns(:assets_chart_data).is_a?(Hash)
    assert assigns(:assets_chart_data).key?(:labels)
    assert assigns(:assets_chart_data).key?(:values)
  end

  test "report action prepares liabilities chart data" do
    get report_balance_sheet_path(@balance_sheet)
    assert_not_nil assigns(:liabilities_chart_data)
    assert assigns(:liabilities_chart_data).is_a?(Hash)
    assert assigns(:liabilities_chart_data).key?(:labels)
    assert assigns(:liabilities_chart_data).key?(:values)
  end

  test "assets chart data groups assets by category" do
    @balance_sheet.assets.create!(
      name: "Cash",
      item_type: "liquid",
      category: "Efectivo",
      amount: 1000.00
    )
    @balance_sheet.assets.create!(
      name: "Stocks",
      item_type: "fixed",
      category: "Inversiones",
      amount: 5000.00
    )

    get report_balance_sheet_path(@balance_sheet)
    chart_data = assigns(:assets_chart_data)

    assert_includes chart_data[:labels], "Efectivo"
    assert_includes chart_data[:labels], "Inversiones"
    assert_includes chart_data[:values], 1000.00
    assert_includes chart_data[:values], 5000.00
  end

  test "liabilities chart data groups liabilities by item_type" do
    @balance_sheet.liabilities.create!(
      name: "Credit Card",
      item_type: "short_term",
      amount: 500.00
    )
    @balance_sheet.liabilities.create!(
      name: "Mortgage",
      item_type: "long_term",
      amount: 100000.00
    )

    get report_balance_sheet_path(@balance_sheet)
    chart_data = assigns(:liabilities_chart_data)

    assert_includes chart_data[:labels], "Short term"
    assert_includes chart_data[:labels], "Long term"
    assert_includes chart_data[:values], 500.00
    assert_includes chart_data[:values], 100000.00
  end

  test "assets chart data handles nil category" do
    @balance_sheet.assets.create!(
      name: "Uncategorized Asset",
      item_type: "liquid",
      category: nil,
      amount: 2000.00
    )

    get report_balance_sheet_path(@balance_sheet)
    chart_data = assigns(:assets_chart_data)

    assert_includes chart_data[:labels], "Sin categoría"
  end
end
