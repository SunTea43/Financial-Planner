require "test_helper"

class BalanceSheets::SummaryComponentTest < ViewComponent::TestCase
  test "summary renders successfully" do
    balance_sheet = balance_sheets(:one)

    render_inline(BalanceSheets::SummaryComponent.new(balance_sheet: balance_sheet))

    assert page.present?
    assert_selector ".card"
    assert_selector ".text-success, .text-danger"
  end
end
