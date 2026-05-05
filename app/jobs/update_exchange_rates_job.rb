class UpdateExchangeRatesJob < ApplicationJob
  queue_as :default

  def perform(base_currencies: nil)
    currencies = Array(base_currencies).presence || Account.distinct.pluck(:preferred_currency)
    currencies = (currencies + [ Account::DEFAULT_CURRENCY ]).uniq

    currencies.each do |base_currency|
      ExchangeRates::RefreshBaseRatesService.new(base_currency: base_currency).call
    rescue StandardError => e
      Rails.logger.error("UpdateExchangeRatesJob: failed for #{base_currency}: #{e.message}")
    end
  end
end
