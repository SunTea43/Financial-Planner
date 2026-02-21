require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    # Create controlled test data to verify calculations
    @account = accounts(:one)
    @user.balance_sheets.destroy_all # Clear fixtures to have predictable results

    @bs1 = @user.balance_sheets.create!(
      account: @account,
      recorded_at: 2.days.ago
    )
    @bs1.assets.create!(name: "A", amount: 1000, asset_type: "liquid")
    @bs1.liabilities.create!(name: "L", amount: 200, liability_type: "short_term")
    @bs1.save! # Should be 800

    @bs2 = @user.balance_sheets.create!(
      account: @account,
      recorded_at: 1.day.ago
    )
    @bs2.assets.create!(name: "A", amount: 2000, asset_type: "liquid")
    @bs2.liabilities.create!(name: "L", amount: 800, liability_type: "short_term")
    @bs2.save! # Should be 1200
    # Total: 2000, Count: 2, Average: 1000
  end

  test "should get balance sheet report with correct calculations" do
    get balance_sheet_reports_url
    assert_response :success

    # Check for the expected values
    # BS1: Assets 1000, Liab 200, Net 800
    # BS2: Assets 2000, Liab 800, Net 1200
    # Avg: Assets (3000/2)=1500, Liab (1000/2)=500, Net (2000/2)=1000
    assert_match "2", response.body
    assert_match "$1,500.00", response.body # Avg Assets
    assert_match "$500.00", response.body   # Avg Liab
    assert_match "$1,000.00", response.body # Avg Net Worth

    # Verify the new labels are present
    assert_select "h6", text: "Activos Promedio"
    assert_select "h6", text: "Pasivos Promedio"
    assert_select "h6", text: "Patrimonio Neto Promedio"
  end

  test "should filter balance sheet report by account" do
    other_account = accounts(:two)
    bs_other = @user.balance_sheets.create!(
      account: other_account,
      recorded_at: Time.now
    )
    bs_other.assets.create!(name: "O", amount: 5000, asset_type: "liquid")
    bs_other.save!

    get balance_sheet_reports_url(account_id: @account.id)
    assert_response :success

    # Filtered results (same as first test because other account is excluded)
    assert_match "2", response.body
    assert_match "$1,500.00", response.body
    assert_match "$500.00", response.body
    assert_match "$1,000.00", response.body

    # Ensure the 5000 from the other account is NOT showing
    assert_no_match "$5,000.00", response.body
  end

  test "balance sheet net worth should update correctly when items are marked for destruction" do
    bs = @user.balance_sheets.create!(recorded_at: Time.now)
    asset1 = bs.assets.create!(name: "A1", amount: 100, asset_type: "liquid")
    bs.assets.create!(name: "A2", amount: 200, asset_type: "liquid")
    bs.save!

    assert_equal 300, bs.reload.net_worth

    # Simulate nested attributes deletion
    bs.assets_attributes = { "0" => { id: asset1.id, _destroy: "1" } }
    bs.save!

    assert_equal 200, bs.reload.net_worth
  end
end
