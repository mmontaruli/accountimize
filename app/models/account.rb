class Account < ActiveRecord::Base
  has_many :clients, :dependent => :destroy
  has_many :estimates, :through => :clients
  
  accepts_nested_attributes_for :clients, :allow_destroy => true
  
end
