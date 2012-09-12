class UserMailer < ActionMailer::Base
  default from: "no-reply@accountimize.com"

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
