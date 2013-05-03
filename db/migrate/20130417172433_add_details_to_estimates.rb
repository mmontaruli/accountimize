class AddDetailsToEstimates < ActiveRecord::Migration
  def change
    add_column :estimates, :is_sent, :boolean, :default => false
    add_column :estimates, :is_archived, :boolean, :default => false
  end
end
