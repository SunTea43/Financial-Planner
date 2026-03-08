require "test_helper"
require "cell/test_case"

class BalanceSheetCellTest < Cell::TestCase
  test "summary renders successfully" do
    balance_sheet = balance_sheets(:one)

    # Render the cell's summary view
    html = cell(BalanceSheetCell, balance_sheet).call(:summary)

    assert html.present?
    # Verify that the localized net worth is present
    # In COP it should have $ and either , or . depending on how number_to_currency is acting
    assert_match "$", html.to_s

    # Verify that BalanceSheet human attribute names are used (checking Net Worth translation)
    assert_match BalanceSheet.human_attribute_name(:net_worth), html.to_s
  end
end
