class MessageMailer < ActionMailer::Base
  default from: "no-reply@accountimize.com"

  def email_message(message)
    @message = message
    mail to: message.user.email, subject: message.subject
  end
end
