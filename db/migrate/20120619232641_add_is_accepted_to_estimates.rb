class AddIsAcceptedToEstimates < ActiveRecord::Migration
  def change
    add_column :estimates, :is_accepted, :boolean
  end
end
