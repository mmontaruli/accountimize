class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :country
      t.string :address_street_1
      t.string :address_street_2
      t.string :address_city
      t.string :address_state
      t.string :address_zip

      t.timestamps
    end
  end
end
