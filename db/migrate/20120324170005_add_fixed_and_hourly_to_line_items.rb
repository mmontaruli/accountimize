class AddFixedAndHourlyToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :hours_qty, :integer
    add_column :line_items, :hours_rate, :decimal
    add_column :line_items, :fixed_qty, :integer
    add_column :line_items, :fixed_rate, :decimal
    add_column :line_items, :price_type, :string
  end
end
