require "test_helper"

class ExchangeRatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "refresh enqueues UpdateExchangeRatesJob for all currencies when no base_currency given" do
    assert_enqueued_with(job: UpdateExchangeRatesJob) do
      post refresh_exchange_rates_path
    end

    assert_response :redirect
  end

  test "refresh enqueues UpdateExchangeRatesJob with specific base_currency when valid" do
    assert_enqueued_with(job: UpdateExchangeRatesJob, args: [ { base_currencies: [ "USD" ] } ]) do
      post refresh_exchange_rates_path(base_currency: "USD")
    end

    assert_response :redirect
  end

  test "refresh falls back to all currencies when base_currency is unsupported" do
    assert_enqueued_with(job: UpdateExchangeRatesJob) do
      post refresh_exchange_rates_path(base_currency: "XYZ")
    end

    assert_response :redirect
  end

  test "refresh redirects unauthenticated users" do
    sign_out @user

    post refresh_exchange_rates_path

    assert_redirected_to new_user_session_path
  end
end
