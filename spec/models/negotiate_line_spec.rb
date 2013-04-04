require 'spec_helper'

describe NegotiateLine do
	context "is accepted" do
		before do
			user = create(:user)
			estimate = create(:estimate, send_to_contact: user.id, client_id: user.client_id)
			line_item = create(:line_item, estimate_id: estimate.id)
			@negotiate_line = create(:negotiate_line, line_item_id: line_item.id)
			@negotiate_line.is_accepted = true
			@negotiate_line.save
		end
		it "should set line item to accepted" do
			@negotiate_line.line_item.is_accepted.should == true
		end
		it "should set line item values to negotiate line values" do
			@negotiate_line.line_item.total_price.should == @negotiate_line.total_price
		end
	end
end