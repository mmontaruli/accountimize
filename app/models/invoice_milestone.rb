class InvoiceMilestone < ActiveRecord::Base
	belongs_to :invoice_schedule
	belongs_to :invoice

	validates :estimate_percentage, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
end
