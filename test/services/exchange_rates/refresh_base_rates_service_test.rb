require "test_helper"

class ExchangeRates::RefreshBaseRatesServiceTest < ActiveSupport::TestCase
  FIXED_FETCHED_AT = Time.zone.parse("2026-01-01 00:00:00").freeze

  test "call persists rows for supported currencies and returns count" do
    payload = {
      fetched_at: FIXED_FETCHED_AT,
      rates: { "USD" => 0.00025, "EUR" => 0.00022, "XYZ" => 0.5 },
      source: "open_er_api"
    }
    stub_client = build_stub_client(payload)

    ExchangeRate.where(base_currency: "COP", fetched_at: FIXED_FETCHED_AT).delete_all

    service = ExchangeRates::RefreshBaseRatesService.new(base_currency: "COP", client: stub_client)

    assert_difference("ExchangeRate.count", 2) do
      result = service.call
      assert_equal 2, result
    end
  end

  test "call skips the base currency from the result rows" do
    payload = {
      fetched_at: FIXED_FETCHED_AT,
      rates: { "COP" => 1.0, "USD" => 0.00025 },
      source: "open_er_api"
    }
    stub_client = build_stub_client(payload)

    ExchangeRate.where(base_currency: "COP", fetched_at: FIXED_FETCHED_AT).delete_all

    service = ExchangeRates::RefreshBaseRatesService.new(base_currency: "COP", client: stub_client)

    assert_difference("ExchangeRate.count", 1) do
      service.call
    end
  end

  test "call returns 0 when no supported currency rates are present" do
    payload = { fetched_at: FIXED_FETCHED_AT, rates: {}, source: "open_er_api" }
    stub_client = build_stub_client(payload)

    service = ExchangeRates::RefreshBaseRatesService.new(base_currency: "COP", client: stub_client)

    assert_equal 0, service.call
  end

  test "call re-raises when client raises" do
    failing_client = Object.new
    def failing_client.fetch_latest(base_currency:) = raise "API error"

    service = ExchangeRates::RefreshBaseRatesService.new(base_currency: "COP", client: failing_client)

    assert_raises(RuntimeError) { service.call }
  end

  private

  def build_stub_client(payload)
    client = Object.new
    client.define_singleton_method(:fetch_latest) { |base_currency:| payload }
    client
  end
end
