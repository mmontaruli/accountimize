require 'spec_helper'

describe Message do
	it "should email message" do
		message = create(:message)
		ActionMailer::Base.deliveries.last.to.should == [message.user.email]
	end
end
