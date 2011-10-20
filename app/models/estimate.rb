class Estimate < ActiveRecord::Base
  validates :date, :number, :presence => true
  validates :number, :numericality => {:greater_than_or_equal_to => 1}
  
end
