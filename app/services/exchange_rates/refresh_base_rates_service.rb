module ExchangeRates
  class RefreshBaseRatesService
    def initialize(base_currency:, client: ExchangeRates::Client.new)
      @base_currency = base_currency
      @client = client
    end

    def call
      payload = @client.fetch_latest(base_currency: @base_currency)
      rows = build_rows(payload)
      return 0 if rows.empty?

      ExchangeRate.upsert_all(rows, unique_by: :index_exchange_rates_on_base_quote_fetched_at)
      rows.size
    rescue StandardError => e
      Rails.logger.error("Failed to refresh exchange rates for #{@base_currency}: #{e.message}")
      raise
    end

    private

    def build_rows(payload)
      supported = Account::SUPPORTED_CURRENCIES.keys
      rates = payload.fetch(:rates)
      fetched_at = payload.fetch(:fetched_at)
      source = payload.fetch(:source)
      now = Time.current

      supported.filter_map do |quote_currency|
        next if quote_currency == @base_currency

        raw_rate = rates[quote_currency]
        next if raw_rate.blank?

        {
          base_currency: @base_currency,
          quote_currency: quote_currency,
          rate: BigDecimal(raw_rate.to_s),
          fetched_at: fetched_at,
          source: source,
          created_at: now,
          updated_at: now
        }
      end
    end
  end
end
