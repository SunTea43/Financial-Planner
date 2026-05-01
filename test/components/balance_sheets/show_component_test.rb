require "test_helper"

class BalanceSheets::ShowComponentTest < ViewComponent::TestCase
  setup do
    @balance_sheet = balance_sheets(:one)
  end

  test "renders card with balance sheet date" do
    render_inline(BalanceSheets::ShowComponent.new(balance_sheet: @balance_sheet))

    assert_selector ".card"
    assert_selector ".card-header"
    assert_text @balance_sheet.recorded_at.strftime("%d/%m/%Y %H:%M")
  end

  test "renders total assets and total liabilities sections" do
    @balance_sheet.total_assets = 5000.00
    @balance_sheet.total_liabilities = 2000.00

    render_inline(BalanceSheets::ShowComponent.new(balance_sheet: @balance_sheet))

    assert_selector ".text-success"
    assert_selector ".text-danger"
  end

  test "renders liquid assets list" do
    @balance_sheet.assets.create!(name: "Cuenta corriente", item_type: "liquid", amount: 3000.00)

    render_inline(BalanceSheets::ShowComponent.new(balance_sheet: @balance_sheet))

    assert_text "Cuenta corriente"
    assert_selector ".list-group"
  end

  test "renders fixed assets list" do
    @balance_sheet.assets.create!(name: "Inmueble", item_type: "fixed", amount: 100_000.00)

    render_inline(BalanceSheets::ShowComponent.new(balance_sheet: @balance_sheet))

    assert_text "Inmueble"
  end

  test "renders short_term liabilities list" do
    @balance_sheet.liabilities.create!(name: "Tarjeta de crédito", item_type: "short_term", amount: 500.00)

    render_inline(BalanceSheets::ShowComponent.new(balance_sheet: @balance_sheet))

    assert_text "Tarjeta de crédito"
  end

  test "renders long_term liabilities list" do
    @balance_sheet.liabilities.create!(name: "Hipoteca", item_type: "long_term", amount: 80_000.00)

    render_inline(BalanceSheets::ShowComponent.new(balance_sheet: @balance_sheet))

    assert_text "Hipoteca"
  end

  test "renders notes when present" do
    @balance_sheet.notes = "Notas de prueba del balance"

    render_inline(BalanceSheets::ShowComponent.new(balance_sheet: @balance_sheet))

    assert_text "Notas de prueba del balance"
  end

  test "does not render notes section when notes is blank" do
    @balance_sheet.notes = nil

    render_inline(BalanceSheets::ShowComponent.new(balance_sheet: @balance_sheet))

    assert_no_text "Notas"
  end
end
