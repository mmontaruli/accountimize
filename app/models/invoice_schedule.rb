class InvoiceSchedule < ActiveRecord::Base
	belongs_to :estimate
	has_many :invoice_milestones, :dependent => :destroy

	accepts_nested_attributes_for :invoice_milestones, :allow_destroy => true

	validate :total_must_equal_one_hundred_percent

	def total_must_equal_one_hundred_percent
		if total_percent != 100
			errors.add(:invoice_milestones, "Total must equal 100%")
		end
	end

	def total_percent
		invoice_milestones.to_a.sum { |item| item.estimate_percentage || 0 }
	end
end
