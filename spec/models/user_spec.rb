require 'spec_helper'

describe User do
	it "should not allow insecure passwords" do
		User.new.should have(2).error_on(:password)
	end
	it "should not allow a non-email address" do
		User.new.should have(2).error_on(:email)
	end
	it "should send password reset" do
		user = create(:user)
		user.send_password_reset
		user.password_reset_token.should_not be_nil
		ActionMailer::Base.deliveries.last.to.should == [user.email]
	end
end
