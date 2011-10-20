class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.integer :number
      t.date :date

      t.timestamps
    end
  end
end
