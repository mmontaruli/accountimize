require "spec_helper"

describe AccountMailer do
	before(:each) do
    	# @user = create(:user)
    	# @user.client.is_account_master = true
    	# @user.client.save
    	# @user.save
    	vendor = create(:client, is_account_master: true, users_attributes: [attributes_for(:user)])
    	@user = vendor.users.first
	end

	describe "welcome_email" do
		let(:mail) { AccountMailer.welcome_email(@user) }

		it "renders the headers" do
			mail.subject.should eq("Welcome to Accountimize")
			mail.to.should == [@user.email]
			mail.from.should == ["no-reply@accountimize.com"]
		end

		it "renders the body" do
			mail.body.encoded.should match("Welcome to Accountimize, the most interactive and flexible way to send estimates and invoices.")
		end

	end

end
