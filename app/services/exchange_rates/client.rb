require "net/http"
require "json"

module ExchangeRates
  class Client
    API_BASE_URL = ENV.fetch("EXCHANGE_RATES_API_URL", "https://open.er-api.com/v6/latest").freeze

    def fetch_latest(base_currency:)
      uri = URI("#{API_BASE_URL}/#{base_currency}")
      response = perform_request(uri)
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

    def perform_request(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = 5
      http.read_timeout = 10
      http.request(Net::HTTP::Get.new(uri.request_uri))
    end
  end
end
