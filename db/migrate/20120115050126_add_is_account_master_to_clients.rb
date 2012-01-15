class AddIsAccountMasterToClients < ActiveRecord::Migration
  def change
    add_column :clients, :is_account_master, :boolean
  end
end
