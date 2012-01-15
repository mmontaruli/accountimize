class Account < ActiveRecord::Base
  has_many :clients
  has_many :estimates, :through => :clients
end
