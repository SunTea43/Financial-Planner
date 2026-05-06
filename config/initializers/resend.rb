require "resend"

resend_api_key = ENV.fetch("RESEND_API_KEY", "").to_s.strip

if Rails.env.production? && resend_api_key.empty?
  raise "Missing RESEND_API_KEY in production"
end

Resend.api_key = resend_api_key unless resend_api_key.empty?
