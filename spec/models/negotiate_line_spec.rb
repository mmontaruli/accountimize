require 'spec_helper'

describe NegotiateLine do
	context "is accepted" do
		before do
			@negotiate_line = create(:negotiate_line)
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