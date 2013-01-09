class AddPositionToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :position, :integer, :default => 0
  end
end
