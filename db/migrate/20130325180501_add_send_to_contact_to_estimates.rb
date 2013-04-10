class AddSendToContactToEstimates < ActiveRecord::Migration
  def change
    add_column :estimates, :send_to_contact, :integer
  end
end
