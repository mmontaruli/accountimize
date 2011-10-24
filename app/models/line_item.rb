class LineItem < ActiveRecord::Base
  belongs_to :estimate
  
  validates :name, :estimate_id, :presence => true
  validates :estimate_id, :numericality => {:greater_than_or_equal_to => 1}
  
  def total_price
    unit_price * quantity
  end
end
