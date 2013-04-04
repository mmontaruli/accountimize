class EstimateMailer < ActionMailer::Base
  default from: "no-reply@accountimize.com"

  def first_estimate_email(estimate, user, new_pw)
  	@estimate = estimate
  	@user = user
  	@new_pw = new_pw
  	mail to: user.email, subject: "#{estimate.client.account.name} just sent you an estimate via Accountimize"
  end
end
