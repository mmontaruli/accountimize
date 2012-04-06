class CreateNegotiateLines < ActiveRecord::Migration
  def change
    create_table :negotiate_lines do |t|
      t.text :description
      t.integer :line_item_id
      t.integer :line_qty
      t.decimal :line_price
      t.decimal :hours_rate
      t.integer :hours_qty
      t.decimal :fixed_rate
      t.integer :fixed_qty
      t.string :price_type
      t.string :user_negotiating

      t.timestamps
    end
  end
end
