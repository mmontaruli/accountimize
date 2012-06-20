class InvoiceMilestone < ActiveRecord::Base
	belongs_to :invoice_schedule
end
