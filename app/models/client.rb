class Client < ActiveRecord::Base
  belongs_to :account
  has_many :estimates, :dependent => :destroy
  has_many :users, :dependent => :destroy
  accepts_nested_attributes_for :users
  
  validates :name, :presence => true, :uniqueness => true
end
