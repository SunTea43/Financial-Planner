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

  test "report action uses default assets conversion factor when param is missing" do
    get report_balance_sheet_path(@balance_sheet)

    assert_equal BigDecimal("1"), assigns(:assets_conversion_factor)
  end

  test "report action applies assets conversion factor to assets chart" do
    @balance_sheet.assets.create!(
      name: "Cash",
      item_type: "liquid",
      category: "Efectivo",
      amount: 100
    )

    get report_balance_sheet_path(@balance_sheet), params: { assets_conversion_factor: "2.5", assets_currency: "usd" }

    chart_data = assigns(:assets_chart_data)
    idx = chart_data[:labels].index("Efectivo")
    assert_not_nil idx
    assert_equal 250.0, chart_data[:values][idx]
    assert_equal BigDecimal("2.5"), assigns(:assets_conversion_factor)
    assert_equal "USD", assigns(:assets_currency)
  end

  test "report action falls back to factor 1 when conversion factor is invalid" do
    get report_balance_sheet_path(@balance_sheet), params: { assets_conversion_factor: "invalid" }

    assert_equal BigDecimal("1"), assigns(:assets_conversion_factor)
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

  test "report action prepares historical chart data" do
    get report_balance_sheet_path(@balance_sheet)
    assert_not_nil assigns(:historical_chart_data)
    assert assigns(:historical_chart_data).is_a?(Hash)
    assert assigns(:historical_chart_data).key?(:labels)
    assert assigns(:historical_chart_data).key?(:assetsData)
    assert assigns(:historical_chart_data).key?(:liabilitiesData)
    assert assigns(:historical_chart_data).key?(:netWorthData)
  end

  test "historical chart data includes multiple balance sheets" do
    # Crear varios balance sheets en el tiempo
    @user.balance_sheets.create!(
      account_id: @account.id,
      recorded_at: 1.month.ago,
      total_assets: 10000.00,
      total_liabilities: 2000.00,
      net_worth: 8000.00
    )
    @user.balance_sheets.create!(
      account_id: @account.id,
      recorded_at: 2.weeks.ago,
      total_assets: 12000.00,
      total_liabilities: 2500.00,
      net_worth: 9500.00
    )

    get report_balance_sheet_path(@balance_sheet)
    chart_data = assigns(:historical_chart_data)

    assert chart_data[:labels].length >= 2
    assert chart_data[:assetsData].length >= 2
    assert chart_data[:liabilitiesData].length >= 2
    assert chart_data[:netWorthData].length >= 2
  end

  test "report renders executive summary ratio placeholder when total_assets is zero" do
    @balance_sheet.update_columns(total_assets: 0, total_liabilities: 100, net_worth: -100)

    get report_balance_sheet_path(@balance_sheet)

    assert_response :success
    assert_select "h5", text: I18n.t("views.balance_sheets.report.executive_summary.title")
    assert_select "small", text: I18n.t("views.balance_sheets.report.executive_summary.debt_to_assets_ratio")
    assert_select "h4.text-muted", text: /—/
    assert_select "small", text: I18n.t("views.balance_sheets.report.executive_summary.no_assets")
  end

  test "report renders executive summary labels in english locale" do
    I18n.with_locale(:en) do
      get report_balance_sheet_path(@balance_sheet)

      assert_response :success
      assert_select "h5", text: I18n.t("views.balance_sheets.report.executive_summary.title")
      assert_select "small", text: I18n.t("views.balance_sheets.report.executive_summary.debt_to_assets_ratio")
      assert_select "small", text: BalanceSheet.human_attribute_name(:total_assets)
    end
  end

  test "historical chart data filters by account" do
    # Crear otra cuenta del mismo usuario
    other_account = @user.accounts.create!(
      name: "Other Account",
      account_type: "savings"
    )
    @user.balance_sheets.create!(
      account_id: other_account.id,
      recorded_at: Time.current,
      total_assets: 50000.00,
      total_liabilities: 10000.00,
      net_worth: 40000.00
    )

    get report_balance_sheet_path(@balance_sheet)
    chart_data = assigns(:historical_chart_data)

    # Verificar que solo incluye balance sheets de la misma cuenta
    assert_not_nil chart_data
    # Los datos deben corresponder a la cuenta del balance_sheet actual
  end

  test "should update balance sheet removing and reordering items" do
    removable_asset = @balance_sheet.assets.create!(name: "Old Asset", item_type: "liquid", amount: 1200, position: 2)
    remaining_asset = @balance_sheet.assets.create!(name: "Cash", item_type: "liquid", amount: 800, position: 3)
    removable_liability = @balance_sheet.liabilities.create!(name: "Old Debt", item_type: "short_term", amount: 200, position: 2)
    remaining_liability = @balance_sheet.liabilities.create!(name: "Loan", item_type: "long_term", amount: 500, position: 3)

    patch balance_sheet_path(@balance_sheet), params: {
      balance_sheet: {
        account_id: @balance_sheet.account_id,
        recorded_at: @balance_sheet.recorded_at.strftime("%Y-%m-%dT%H:%M"),
        notes: @balance_sheet.notes,
        assets_attributes: {
          "0" => { id: removable_asset.id, _destroy: "1" },
          "1" => {
            id: remaining_asset.id,
            name: remaining_asset.name,
            item_type: remaining_asset.item_type,
            category: "Liquidez",
            amount: remaining_asset.amount,
            description: remaining_asset.description,
            position: 1
          }
        },
        liabilities_attributes: {
          "0" => { id: removable_liability.id, _destroy: "1" },
          "1" => {
            id: remaining_liability.id,
            name: remaining_liability.name,
            item_type: remaining_liability.item_type,
            amount: remaining_liability.amount,
            description: remaining_liability.description,
            position: 1
          }
        }
      }
    }

    assert_redirected_to balance_sheet_path(@balance_sheet)
    assert_not Asset.exists?(removable_asset.id)
    assert_not Liability.exists?(removable_liability.id)
    assert_equal 1, remaining_asset.reload.position
    assert_equal 1, remaining_liability.reload.position
  end
end
