module BalanceSheetsHelper
  def converted_asset_amount(amount, conversion_factor)
    amount.to_d * conversion_factor.to_d
  end

  def converted_currency_format_options(target_currency)
    return {} unless target_currency.present?

    opts = Account::SUPPORTED_CURRENCIES[target_currency]
    return {} unless opts

    opts.slice(:unit, :precision, :format)
  end
end
