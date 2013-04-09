class Client < ActiveRecord::Base
  belongs_to :account
  has_many :estimates, :dependent => :destroy
  has_many :users, :dependent => :destroy, :inverse_of => :client
  has_many :invoices
  accepts_nested_attributes_for :users

  validates :name, :presence => true
  validates :name, :uniqueness => {:scope => :account_id}
  validates :users, :presence => true

end
