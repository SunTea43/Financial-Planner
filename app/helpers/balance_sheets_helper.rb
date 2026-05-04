module BalanceSheetsHelper
  def converted_asset_amount(amount, conversion_factor)
    amount.to_d * conversion_factor.to_d
  end

  def converted_asset_currency_unit(assets_currency)
    assets_currency.present? ? "#{assets_currency} " : nil
  end
end
