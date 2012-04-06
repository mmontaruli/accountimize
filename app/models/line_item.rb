class LineItem < ActiveRecord::Base
  belongs_to :estimate
  has_many :negotiate_lines, :dependent => :destroy
  
  accepts_nested_attributes_for :negotiate_lines, :allow_destroy => true
    
  def total_price
    if unit_price and quantity and is_enabled?
      unit_price * quantity
    else
      0
    end
  end
end
