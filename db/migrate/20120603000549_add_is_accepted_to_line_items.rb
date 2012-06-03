class AddIsAcceptedToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :is_accepted, :boolean
  end
end
