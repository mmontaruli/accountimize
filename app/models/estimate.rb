class Estimate < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  
  validates :date, :number, :presence => true
  validates :number, :numericality => {:greater_than_or_equal_to => 1}
  
  def total_price
    line_items.where(:is_enabled => true).to_a.sum { |item| item.total_price }
  end
  
end
