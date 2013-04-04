require 'spec_helper'

describe User do
	it "should not allow insecure passwords" do
		build(:user, password: "matt").should_not be_valid
	end
	it "should not allow a non-email address" do
		build(:user, email: "matt").should_not be_valid
	end
	it "should send password reset" do
		user = create(:user)
		user.send_password_reset
		user.password_reset_token.should_not be_nil
		ActionMailer::Base.deliveries.last.to.should == [user.email]
	end
	context "client user email already exists" do
		before do
			same_client_name = "Google"
			@taken_client_email = "fred@google.com"
			@other_client = create(:client, is_account_master: false, name: same_client_name)
			user = create(:user, email: @taken_client_email, client_id: @other_client.id)
			me_vendor = create(:user)
			me_vendor.client.is_account_master = true
			me_vendor.client.save
			@my_client = create(:client, name: same_client_name, account_id: me_vendor.client.account.id)
		end
		it "should allow another client with the same email address to be created in another account" do
			build(:user, email: @taken_client_email, client_id: @my_client.id).should be_valid
		end
		it "should not allow another client with the same email address to be created in the same account" do
			other_client_2 = create(:client, account_id: @other_client.account.id)
			build(:user, email: @taken_client_email, client_id: other_client_2.id).should_not be_valid
		end
		it "should allow a vendor with the same email address to be created" do
			new_account = create(:account)
			new_vendor = create(:client, is_account_master: true, account_id: new_account.id)
			new_vendor_user = build(:user, client_id: new_vendor.id, email: @taken_client_email).should be_valid
		end
	end
	context "vendor user email already exists" do
		before do
			@taken_vendor_email = "fred@google.com"
			other_vendor = create(:client, is_account_master: true)
			vendor_user = create(:user, client_id: other_vendor.id, email: @taken_vendor_email)
		end
		it "should not allow another vendor with the same email to be created" do
			new_account = create(:account)
			new_vendor = create(:client, is_account_master: true, account_id: new_account.id)
			new_vendor_user = build(:user, client_id: new_vendor.id, email: @taken_vendor_email).should_not be_valid
		end
		it "should allow a client with the same email to be created under another account" do
			build(:user, email: @taken_vendor_email).should be_valid
		end
	end
	context "create new client user with temporary password" do
		before do
			@client = create(:client)
		end
		it "should generate a temporary password and save client user" do
			user = build(:user, password: nil, password_confirmation: nil, client_id: @client.id)
			user.save
			user.save.should == true
		end
		it "should not allow creating a vendor user without a password" do
			@client.is_account_master = true
			@client.save
			user = build(:user, password: nil, password_confirmation: nil, client_id: @client.id)
			user.save
			user.save.should == false
		end
	end
end
