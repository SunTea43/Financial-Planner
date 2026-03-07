class BalanceSheetCell < Cell::ViewModel
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper
  include Rails.application.routes.url_helpers

  def show
    render(view: :show)
  end

  def summary
    render(view: :summary)
  end

  def comparison
    render(view: :comparison)
  end

  private

  def comparison_data
    @comparison_data ||= balance_sheet.comparison_with_previous
  end

  def balance_sheet
    @balance_sheet ||= model
  end

  def liquid_assets
    balance_sheet.assets.select { |a| a.item_type == "liquid" }
  end

  def fixed_assets
    balance_sheet.assets.select { |a| a.item_type == "fixed" }
  end

  def short_term_liabilities
    balance_sheet.liabilities.select { |l| l.item_type == "short_term" }
  end

  def long_term_liabilities
    balance_sheet.liabilities.select { |l| l.item_type == "long_term" }
  end
end
