class AddIsAcceptedToNegotiateLines < ActiveRecord::Migration
  def change
    add_column :negotiate_lines, :is_accepted, :boolean
  end
end
