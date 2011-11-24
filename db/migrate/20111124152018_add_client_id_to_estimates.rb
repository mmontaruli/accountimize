class AddClientIdToEstimates < ActiveRecord::Migration
  def change
    add_column :estimates, :client_id, :integer
  end
end
