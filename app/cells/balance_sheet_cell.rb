class BalanceSheetCell < Cell::ViewModel
  include ActionView::Helpers::NumberHelper

  def show
    render(view: :show)
  end

  def summary
    render(view: :summary)
  end

  private

  def balance_sheet
    @balance_sheet ||= model
  end

  def liquid_assets
    balance_sheet.assets.select { |a| a.asset_type == "liquid" }
  end

  def fixed_assets
    balance_sheet.assets.select { |a| a.asset_type == "fixed" }
  end

  def short_term_liabilities
    balance_sheet.liabilities.select { |l| l.liability_type == "short_term" }
  end

  def long_term_liabilities
    balance_sheet.liabilities.select { |l| l.liability_type == "long_term" }
  end
end
