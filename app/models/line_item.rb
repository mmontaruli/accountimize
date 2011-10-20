class LineItem < ActiveRecord::Base
  belongs_to :estimate
  
  validates :name, :presence => true
end
