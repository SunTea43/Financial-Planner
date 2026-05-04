require "test_helper"

class ExchangeRates::RefreshBaseRatesServiceTest < ActiveSupport::TestCase
  test "stores rates returned by client" do
    fetched_at = Time.zone.parse("2026-05-04 10:00:00")
    client = Object.new
    def client.fetch_latest(base_currency:)
      {
        fetched_at: Time.zone.parse("2026-05-04 10:00:00"),
        source: "open_er_api",
        rates: {
          "USD" => "0.00025",
          "EUR" => "0.00022",
          "XXX" => "99"
        }
      }
    end

    assert_difference "ExchangeRate.count", 2 do
      count = ExchangeRates::RefreshBaseRatesService.new(base_currency: "COP", client: client).call
      assert_equal 2, count
    end

    assert_equal BigDecimal("0.00025"), ExchangeRate.latest_rate(base_currency: "COP", quote_currency: "USD")
    assert_equal BigDecimal("0.00022"), ExchangeRate.latest_rate(base_currency: "COP", quote_currency: "EUR")
  end

  test "returns zero when client fails" do
    client = Object.new
    def client.fetch_latest(base_currency:)
      raise "network error"
    end

    assert_equal 0, ExchangeRates::RefreshBaseRatesService.new(base_currency: "COP", client: client).call
  end
end
