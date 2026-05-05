class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SMTP_FROM_ADDRESS", "noreply@financialplanner.app").presence || "noreply@financialplanner.app"
  layout "mailer"
end
