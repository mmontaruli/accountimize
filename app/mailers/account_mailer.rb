class AccountMailer < ActionMailer::Base
  default from: "no-reply@accountimize.com"

  def welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to Accountimize"
  end

end
