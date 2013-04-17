class AddIsArchivedToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :is_archived, :boolean, :default => false
  end
end
