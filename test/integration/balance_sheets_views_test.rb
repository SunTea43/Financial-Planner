require "test_helper"

# Integration tests that verify ViewComponents render correctly inside
# balance sheet controller actions (index, show, report).
class BalanceSheetsViewsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @balance_sheet = balance_sheets(:one)
  end

  # --- index ---

  test "index renders summary component for each balance sheet" do
    get balance_sheets_path

    assert_response :success
    assert_select ".card"
  end

  test "index shows formatted net_worth value inside summary component" do
    @balance_sheet.assets.create!(name: "Cuenta", item_type: "liquid", amount: 12_345.00)
    @balance_sheet.save! # triggers calculate_totals callback

    get balance_sheets_path

    assert_response :success
    assert_select ".card-body", text: /12\.345/
  end

  # --- show ---

  test "show renders show component with balance sheet header" do
    get balance_sheet_path(@balance_sheet)

    assert_response :success
    assert_select ".card-header", text: /Balance General/
  end

  test "show renders liquid assets inside show component" do
    @balance_sheet.assets.create!(name: "Efectivo", item_type: "liquid", amount: 1000.00)

    get balance_sheet_path(@balance_sheet)

    assert_response :success
    assert_select ".list-group-item", text: /Efectivo/
  end

  test "show renders short_term liabilities inside show component" do
    @balance_sheet.liabilities.create!(name: "Deuda tarjeta", item_type: "short_term", amount: 300.00)

    get balance_sheet_path(@balance_sheet)

    assert_response :success
    assert_select ".list-group-item", text: /Deuda tarjeta/
  end

  test "show renders notes section when notes are present" do
    @balance_sheet.update!(notes: "Revisión mensual de finanzas")

    get balance_sheet_path(@balance_sheet)

    assert_response :success
    assert_select "p.text-muted", text: /Revisión mensual de finanzas/
  end

  test "show renders comparison component when previous balance sheet exists" do
    @user.balance_sheets.create!(
      account: @balance_sheet.account,
      recorded_at: 1.month.ago,
      total_assets: 4000.00,
      total_liabilities: 1000.00,
      net_worth: 3000.00
    )
    @balance_sheet.update!(
      recorded_at: Time.current,
      total_assets: 5000.00,
      total_liabilities: 1200.00,
      net_worth: 3800.00
    )

    get balance_sheet_path(@balance_sheet)

    assert_response :success
    assert_select ".card-header", text: /Comparativa con Balance Anterior/
  end

  # --- report ---

  test "report renders comparison component inside report view" do
    @user.balance_sheets.create!(
      account: @balance_sheet.account,
      recorded_at: 1.month.ago,
      total_assets: 4000.00,
      total_liabilities: 1000.00,
      net_worth: 3000.00
    )
    @balance_sheet.update!(
      recorded_at: Time.current,
      total_assets: 5000.00,
      total_liabilities: 1200.00,
      net_worth: 3800.00
    )

    get report_balance_sheet_path(@balance_sheet)

    assert_response :success
    assert_select ".card-header", text: /Comparativa con Balance Anterior/
  end

  test "report renders without comparison when no previous balance sheet" do
    get report_balance_sheet_path(@balance_sheet)

    assert_response :success
    assert_select ".card-header", text: /Comparativa con Balance Anterior/, count: 0
  end
end
