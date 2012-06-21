class Account < ActiveRecord::Base
  has_many :clients, :dependent => :destroy
  has_many :estimates, :through => :clients
  has_many :users, :through => :clients
  has_many :invoices, :through => :clients
  
  accepts_nested_attributes_for :clients, :allow_destroy => true
  
  validates :name, :presence => true
  validates :subdomain, :presence => true, :uniqueness => true
  validates :subdomain, :format => { :with =>/^[a-zA-Z0-9]+$/, :message => "can only have letters and numbers" }
  
end
