require 'spec_helper'

describe LineItem do
	before do
		client = create(:client)
		user = create(:user, client_id: client.id)
		estimate = create(:estimate, client_id: client.id, send_to_contact: user.id)
		@line_item = create(:line_item, estimate_id: estimate.id)
	end
	context "is not enabled" do
		it "should total 0" do
			@line_item.is_enabled = false
			@line_item.save
			@line_item.total_price.should == 0
		end
	end
end
