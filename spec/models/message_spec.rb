require 'spec_helper'

describe Message do
	it "should email message" do
		client = create(:client, users_attributes: [attributes_for(:user)])
		user = client.users.first
		message = create(:message, user_id: user.id)
		ActionMailer::Base.deliveries.last.to.should == [message.user.email]
	end
end
