class CreateInvoiceMilestones < ActiveRecord::Migration
  def change
    create_table :invoice_milestones do |t|
      t.integer :order
      t.text :description
      t.integer :estimate_percentage
      t.integer :invoice_schedule_id

      t.timestamps
    end
  end
end
