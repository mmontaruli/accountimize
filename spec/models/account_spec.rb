require 'spec_helper'

describe Account do
	before do
		@account = build(:account)
		@account.name = "Acme Corp"
		@account.subdomain = nil
		@account.save
	end
	it "should generate a subdomain" do
		@account.subdomain.should == "acmecorp"
	end
	it "should generate a different subdomain for a new account with the same name" do
		new_account = build(:account)
		new_account.name = "Acme Corp"
		new_account.subdomain = nil
		new_account.save
		new_account.subdomain.should == "acmecorp0"
	end
	it "should filter out all invalid characters" do
		new_account = build(:account)
		new_account.name = "Acme-Corp_ Hello12.$#[]?()*&^%!"
		new_account.subdomain = nil
		new_account.save
		new_account.subdomain.should == "acmecorphello12"
	end
end
