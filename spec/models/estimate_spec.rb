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
	context "estimate with two line items is created" do
		before do
			@estimate = create(:estimate)
			@line_item_1 = create(:line_item, estimate_id: @estimate.id, position: 2)
			@line_item_2 = create(:line_item, estimate_id: @estimate.id, position: 1)
		end
		it "should order the line items according to position" do
			@estimate.line_items.should == [@line_item_2, @line_item_1]
		end
	end
end
