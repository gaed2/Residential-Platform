class AdminNotifier < ApplicationMailer
  layout 'mailer'

  def notify_user(receiver)
    mail(to: receiver, subject: 'Email testing')
  end
end
