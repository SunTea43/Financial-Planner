require "test_helper"

class ExchangeRates::ClientTest < ActiveSupport::TestCase
  test "fetch_latest returns parsed payload on success" do
    payload = {
      "result" => "success",
      "time_last_update_unix" => 1_000_000,
      "rates" => { "USD" => 0.00025, "EUR" => 0.00022 }
    }
    client = client_with_response(successful_response(payload.to_json))

    result = client.fetch_latest(base_currency: "COP")

    assert_equal({ "USD" => 0.00025, "EUR" => 0.00022 }, result[:rates])
    assert_equal "open_er_api", result[:source]
    assert_kind_of Time, result[:fetched_at]
  end

  test "fetch_latest uses current time when time_last_update_unix is missing" do
    payload = { "result" => "success", "rates" => { "USD" => 0.00025 } }
    client = client_with_response(successful_response(payload.to_json))

    result = client.fetch_latest(base_currency: "COP")

    assert_in_delta Time.current.to_i, result[:fetched_at].to_i, 2
  end

  test "fetch_latest raises when response is not successful" do
    client = client_with_response(failed_response("503"))

    error = assert_raises(RuntimeError) { client.fetch_latest(base_currency: "COP") }
    assert_match "503", error.message
  end

  test "fetch_latest raises when API result is not success" do
    payload = { "result" => "error", "error-type" => "unsupported-code" }
    client = client_with_response(successful_response(payload.to_json))

    assert_raises(RuntimeError) { client.fetch_latest(base_currency: "COP") }
  end

  private

  def client_with_response(response)
    client = ExchangeRates::Client.new
    client.define_singleton_method(:perform_request) { |_uri| response }
    client
  end

  def successful_response(body)
    FakeHTTPResponse.new(body: body, success: true)
  end

  def failed_response(code)
    FakeHTTPResponse.new(code: code, body: "", success: false)
  end

  class FakeHTTPResponse
    attr_reader :code, :body

    def initialize(code: "200", body:, success:)
      @code = code
      @body = body
      @success = success
    end

    def is_a?(klass)
      @success ? klass == Net::HTTPSuccess : false
    end
  end
end
