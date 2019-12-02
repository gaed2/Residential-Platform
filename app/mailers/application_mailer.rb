class ApplicationMailer < ActionMailer::Base
  default from: Figaro.env.MAILER_SENDER
  layout 'mailer'
end
