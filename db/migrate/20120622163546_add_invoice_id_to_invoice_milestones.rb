class AddInvoiceIdToInvoiceMilestones < ActiveRecord::Migration
  def change
    add_column :invoice_milestones, :invoice_id, :integer
  end
end
