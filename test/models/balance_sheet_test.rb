require "test_helper"

class BalanceSheetTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: "test_#{Time.now.to_i}@example.com", password: "password123")
    @account = @user.accounts.create!(name: "Test Account", account_type: "checking")

    @prev_bs = BalanceSheet.create!(
      user: @user,
      account: @account,
      recorded_at: 1.month.ago,
      assets_attributes: [ { name: "Cash", amount: 1000, asset_type: "liquid" } ],
      liabilities_attributes: [ { name: "Loan", amount: 500, liability_type: "short_term" } ]
    )

    @current_bs = BalanceSheet.create!(
      user: @user,
      account: @account,
      recorded_at: Time.current,
      assets_attributes: [
        { name: "Cash", amount: 1200, asset_type: "liquid" },
        { name: "Investment", amount: 500, asset_type: "liquid" }
      ],
      liabilities_attributes: [ { name: "Loan", amount: 400, liability_type: "short_term" } ]
    )
  end

  test "identifies previous balance sheet" do
    assert_equal @prev_bs.id, @current_bs.previous_balance_sheet.id
  end

  test "calculates correct differences in comparison" do
    comparison = @current_bs.comparison_with_previous

    assert_not_nil comparison
    assert_equal 700, comparison[:total_assets_diff].to_f # (1200+500) - 1000 = 700
    assert_equal(-100, comparison[:total_liabilities_diff].to_f) # 400 - 500 = -100
    assert_equal 800, comparison[:net_worth_diff].to_f # (1700-400) - (1000-500) = 1300 - 500 = 800
  end

  test "compares individual items correctly" do
    comparison = @current_bs.comparison_with_previous
    cash_diff = comparison[:assets].find { |a| a[:name] == "Cash" }
    inv_diff = comparison[:assets].find { |a| a[:name] == "Investment" }

    assert_equal 200, cash_diff[:diff].to_f
    assert_equal 500, inv_diff[:diff].to_f
    assert_equal 0, inv_diff[:previous_amount].to_f
  end
end
