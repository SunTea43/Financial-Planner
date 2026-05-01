require "test_helper"

class BalanceSheets::SummaryComponentTest < ViewComponent::TestCase
  setup do
    @balance_sheet = balance_sheets(:one)
  end

  test "renders card wrapper" do
    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: @balance_sheet))

    assert_selector ".card"
    assert_selector ".card-body"
  end

  test "applies text-success class when net_worth is positive" do
    @balance_sheet.net_worth = 1000.00

    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: @balance_sheet))

    assert_selector ".text-success"
    assert_no_selector ".text-danger"
  end

  test "applies text-danger class when net_worth is negative" do
    @balance_sheet.net_worth = -500.00

    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: @balance_sheet))

    assert_selector ".text-danger"
    assert_no_selector ".text-success"
  end

  test "renders human attribute names for total_assets and total_liabilities" do
    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: @balance_sheet))

    assert_text BalanceSheet.human_attribute_name(:total_assets)
    assert_text BalanceSheet.human_attribute_name(:total_liabilities)
    assert_text BalanceSheet.human_attribute_name(:net_worth)
  end
end
