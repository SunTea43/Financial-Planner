require "test_helper"

class ExchangeRateTest < ActiveSupport::TestCase
  test "latest_rate returns most recent rate for pair" do
    ExchangeRate.create!(
      base_currency: "COP",
      quote_currency: "USD",
      rate: BigDecimal("0.000200"),
      fetched_at: 2.hours.ago,
      source: "open_er_api"
    )
    ExchangeRate.create!(
      base_currency: "COP",
      quote_currency: "USD",
      rate: BigDecimal("0.000300"),
      fetched_at: 1.hour.ago,
      source: "open_er_api"
    )

    assert_equal BigDecimal("0.000300"), ExchangeRate.latest_rate(base_currency: "COP", quote_currency: "USD")
  end

  test "latest_rate returns 1 when currencies are equal" do
    assert_equal BigDecimal("1"), ExchangeRate.latest_rate(base_currency: "USD", quote_currency: "USD")
  end

  test "stale? returns false when currencies are equal" do
    assert_not ExchangeRate.stale?(base_currency: "USD", quote_currency: "USD")
  end

  test "stale? returns true when no rate exists for pair" do
    assert ExchangeRate.stale?(base_currency: "COP", quote_currency: "EUR")
  end

  test "stale? returns false when rate is fresh" do
    ExchangeRate.create!(
      base_currency: "COP",
      quote_currency: "USD",
      rate: BigDecimal("0.00025"),
      fetched_at: 1.hour.ago,
      source: "open_er_api"
    )

    assert_not ExchangeRate.stale?(base_currency: "COP", quote_currency: "USD")
  end

  test "stale? returns true when rate is older than threshold" do
    ExchangeRate.create!(
      base_currency: "COP",
      quote_currency: "GBP",
      rate: BigDecimal("0.00025"),
      fetched_at: 25.hours.ago,
      source: "open_er_api"
    )

    assert ExchangeRate.stale?(base_currency: "COP", quote_currency: "GBP")
  end
end
