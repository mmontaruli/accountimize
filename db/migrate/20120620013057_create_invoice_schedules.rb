class CreateInvoiceSchedules < ActiveRecord::Migration
  def change
    create_table :invoice_schedules do |t|
      t.integer :estimate_id

      t.timestamps
    end
  end
end
