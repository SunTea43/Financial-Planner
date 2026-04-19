class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SMTP_FROM_ADDRESS", "from@example.com")
  layout "mailer"
end
