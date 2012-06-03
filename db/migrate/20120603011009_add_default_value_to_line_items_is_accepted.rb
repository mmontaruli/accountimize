class AddDefaultValueToLineItemsIsAccepted < ActiveRecord::Migration
  def change
  	change_column :line_items, :is_accepted, :boolean, :default => false
  end
end
