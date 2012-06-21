class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :number
      t.date :date
      t.integer :client_id

      t.timestamps
    end
  end
end
