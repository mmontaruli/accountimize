require 'spec_helper'

describe Client do
	context "client under different account exists" do
		it "should allow creation of client with same name under current account" do
			taken_name = "Google"
			other_account = create(:account)
			create(:client, name: taken_name, account_id: other_account.id)
			my_account = create(:account)
			my_client = build(:client, name: taken_name, account_id: my_account.id).should be_valid
		end
	end
	context "client under same account exists" do
		it "should not allow creation of client with same name" do
			taken_name = "Google"
			my_account = create(:account)
			my_client = create(:client, name: taken_name, account_id: my_account.id)
			new_client = build(:client, name: taken_name, account_id: my_account.id).should_not be_valid
		end
	end
end
