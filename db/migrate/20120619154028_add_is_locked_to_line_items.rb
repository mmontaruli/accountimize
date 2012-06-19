class AddIsLockedToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :is_locked, :boolean
  end
end
