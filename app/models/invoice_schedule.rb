class InvoiceSchedule < ActiveRecord::Base
	belongs_to :estimate
	has_many :invoice_milestones, :dependent => :destroy
end
