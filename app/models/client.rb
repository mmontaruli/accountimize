class Client < ActiveRecord::Base
  has_many :estimates
  
  validates :name, :presence => true, :uniqueness => true
end
