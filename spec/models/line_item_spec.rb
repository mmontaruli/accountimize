require 'spec_helper'

describe LineItem do
	before do
		@line_item = create(:line_item)
	end
	context "is not enabled" do
		it "should total 0" do
			@line_item.is_enabled = false
			@line_item.save
			@line_item.total_price.should == 0
		end
	end
end
