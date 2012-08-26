require 'spec_helper'

describe Estimate do
	context "is accepted" do
		before do
			@estimate = create(:estimate)
			line_item = create(:line_item, estimate_id: @estimate.id)
		end
		it "should have all line items accepted" do
			@estimate.is_accepted = true
			@estimate.save
			line_item = @estimate.line_items[0]
			line_item.is_accepted.should == true
		end
	end
end
