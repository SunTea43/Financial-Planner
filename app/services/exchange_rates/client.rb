require "net/http"
require "json"

module ExchangeRates
  class Client
    API_BASE_URL = ENV.fetch("EXCHANGE_RATES_API_URL", "https://open.er-api.com/v6/latest").freeze

    def fetch_latest(base_currency:)
      uri = URI("#{API_BASE_URL}/#{base_currency}")
      response = Net::HTTP.get_response(uri)
      raise "Exchange rates request failed with status #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      payload = JSON.parse(response.body)
      raise "Exchange rates API returned unsuccessful result" unless payload["result"] == "success"

      {
        fetched_at: fetched_at_from(payload),
        rates: payload.fetch("rates", {}),
        source: "open_er_api"
      }
    end

    private

    def fetched_at_from(payload)
      unix_timestamp = payload["time_last_update_unix"]
      return Time.current if unix_timestamp.blank?

      Time.zone.at(unix_timestamp.to_i)
    end
  end
end
