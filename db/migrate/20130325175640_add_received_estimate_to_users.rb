class AddReceivedEstimateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :received_estimate, :boolean
  end
end
