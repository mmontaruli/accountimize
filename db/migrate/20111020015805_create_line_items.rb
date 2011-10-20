class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :number
      t.string :name
      t.integer :quantity
      t.decimal :unit_price, :scale => 2
      t.boolean :is_enabled
      t.integer :estimate_id

      t.timestamps
    end
  end
end
