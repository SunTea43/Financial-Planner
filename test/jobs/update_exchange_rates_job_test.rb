require "test_helper"

class UpdateExchangeRatesJobTest < ActiveSupport::TestCase
  test "refreshes rates for provided base currencies" do
    call_log = []
    original_service = ExchangeRates::RefreshBaseRatesService

    stubbed_factory = Class.new do
      define_method(:initialize) do |base_currency:|
        @base_currency = base_currency
      end

      define_method(:call) do
        call_log << @base_currency
      end
    end

    ExchangeRates.send(:remove_const, :RefreshBaseRatesService)
    ExchangeRates.const_set(:RefreshBaseRatesService, stubbed_factory)

    UpdateExchangeRatesJob.perform_now(base_currencies: [ "USD", "USD" ])

    assert_includes call_log, "USD"
    assert_includes call_log, Account::DEFAULT_CURRENCY
  ensure
    ExchangeRates.send(:remove_const, :RefreshBaseRatesService)
    ExchangeRates.const_set(:RefreshBaseRatesService, original_service)
  end
end
