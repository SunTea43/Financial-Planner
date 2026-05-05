class ExchangeRatesController < ApplicationController
  def refresh
    base_currency = parse_base_currency
    if base_currency
      UpdateExchangeRatesJob.perform_later(base_currencies: [ base_currency ])
    else
      UpdateExchangeRatesJob.perform_later
    end
    redirect_back_or_to root_path, notice: I18n.t("controllers.exchange_rates.refresh_enqueued")
  end

  private

  def parse_base_currency
    raw = params[:base_currency].to_s.upcase.gsub(/[^A-Z]/, "").first(3)
    Account::SUPPORTED_CURRENCIES.key?(raw) ? raw : nil
  end
end
