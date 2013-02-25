# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Accountimize::Application.initialize!

# Configure production servers to send email
if Rails.env.production?
	config.action_mailer.delivery_method = :smtp
	ActionMailer::Base.smtp_settings = {
  		:address  => "smtp.mandrillapp.com",
  		:port  => 587,
  		:user_name  => "app11566888@heroku.com",
  		:password  => "Gp4sScBcJHnYUaiXi3wLKw",
  		:authentication  => :login
	}
	config.action_mailer.raise_delivery_errors = true
end
