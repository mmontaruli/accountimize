class Estimate < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  
  accepts_nested_attributes_for :line_items, :allow_destroy => true
  
  validates :date, :number, :presence => true
  validates :number, :numericality => {:greater_than_or_equal_to => 1}
  
  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
  
end
