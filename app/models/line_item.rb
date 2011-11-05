class LineItem < ActiveRecord::Base
  belongs_to :estimate
  
  #validates :estimate_id, :presence => true
  #validates :estimate_id, :numericality => {:greater_than_or_equal_to => 1}
  
  def total_price
    if unit_price and quantity and is_enabled?
      unit_price * quantity
    else
      0
    end
  end
end
