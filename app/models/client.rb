class Client < ActiveRecord::Base
  belongs_to :account
  has_many :estimates
  
  validates :name, :presence => true, :uniqueness => true
end
