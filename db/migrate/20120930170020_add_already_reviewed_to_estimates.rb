class AddAlreadyReviewedToEstimates < ActiveRecord::Migration
  def change
    add_column :estimates, :already_reviewed, :boolean
  end
end
