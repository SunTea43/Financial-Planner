require "test_helper"

class ExchangeRatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "refresh enqueues UpdateExchangeRatesJob and redirects" do
    assert_enqueued_with(job: UpdateExchangeRatesJob) do
      post refresh_exchange_rates_path
    end

    assert_response :redirect
  end

  test "refresh redirects unauthenticated users" do
    sign_out @user

    post refresh_exchange_rates_path

    assert_redirected_to new_user_session_path
  end
end
