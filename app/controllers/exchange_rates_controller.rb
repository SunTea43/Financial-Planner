class ExchangeRatesController < ApplicationController
  def refresh
    UpdateExchangeRatesJob.perform_later
    redirect_back_or_to root_path, notice: I18n.t("controllers.exchange_rates.refresh_enqueued")
  end
end
