require "application_system_test_case"

class AssetHistoryTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "visiting asset history" do
    account = accounts(:one)

    bs1 = BalanceSheet.create!(user: @user, account: account, recorded_at: 1.month.ago)
    Asset.create!(balance_sheet: bs1, name: "Gold", amount: 1000, asset_type: "fixed")

    bs2 = BalanceSheet.create!(user: @user, account: account, recorded_at: Time.current)
    Asset.create!(balance_sheet: bs2, name: "Gold", amount: 1200, asset_type: "fixed")

    visit balance_sheet_url(bs2)

    assert_link "Gold"
    click_on "Gold"

    assert_selector "h1", text: "Historial: Gold"
    assert_selector "canvas[data-controller='chart']"

    # Check if chart data attribute contains correct values
    canvas = find("canvas")
    data = JSON.parse(canvas["data-chart-data-value"])

    assert_equal 2, data["labels"].length
    # Amounts should be floats (or numbers in JSON)
    assert_equal [ 1000.0, 1200.0 ], data["datasets"][0]["data"]
  end

  test "history tracks by name across different asset types and categories" do
    account = accounts(:one)

    # Asset starts as liquid
    bs1 = BalanceSheet.create!(user: @user, account: account, recorded_at: 2.months.ago)
    Asset.create!(balance_sheet: bs1, name: "Emergency Fund", amount: 5000, asset_type: "liquid", category: "savings")

    # Asset tracked as fixed property later (maybe logic change or user error, but history should persist)
    bs2 = BalanceSheet.create!(user: @user, account: account, recorded_at: 1.month.ago)
    # Different type and category but same name
    Asset.create!(balance_sheet: bs2, name: "Emergency Fund", amount: 5500, asset_type: "fixed", category: "other")

    # Visit the latest one
    bs3 = BalanceSheet.create!(user: @user, account: account, recorded_at: Time.current)
    latest_asset = Asset.create!(balance_sheet: bs3, name: "Emergency Fund", amount: 6000, asset_type: "liquid", category: "savings")

    visit financial_asset_path(latest_asset)

    assert_selector "h1", text: "Historial: Emergency Fund"

    canvas = find("canvas")
    data = JSON.parse(canvas["data-chart-data-value"])

    # Should include all 3 points because names match
    assert_equal 3, data["labels"].length
    assert_equal [ 5000.0, 5500.0, 6000.0 ], data["datasets"][0]["data"]
  end

  test "visiting liability history" do
    account = accounts(:one)

    bs1 = BalanceSheet.create!(user: @user, account: account, recorded_at: 1.month.ago)
    Liability.create!(balance_sheet: bs1, name: "Credit Card", amount: 500, liability_type: "short_term")

    bs2 = BalanceSheet.create!(user: @user, account: account, recorded_at: Time.current)
    Liability.create!(balance_sheet: bs2, name: "Credit Card", amount: 300, liability_type: "short_term")

    visit balance_sheet_url(bs2)

    assert_link "Credit Card"
    click_on "Credit Card"

    assert_selector "h1", text: "Historial: Credit Card"
    assert_selector "canvas[data-controller='chart']"

    canvas = find("canvas")
    data = JSON.parse(canvas["data-chart-data-value"])

    assert_equal 2, data["labels"].length
    assert_equal [ 500.0, 300.0 ], data["datasets"][0]["data"]
  end
end
