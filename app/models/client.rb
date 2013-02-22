class Client < ActiveRecord::Base
  belongs_to :account
  has_many :estimates, :dependent => :destroy
  has_many :users, :dependent => :destroy, :inverse_of => :client
  has_many :invoices
  accepts_nested_attributes_for :users

  #validates :name, :presence => true, :uniqueness => true
  validates :name, :presence => true
  #validate :name_under_same_account_must_be_unique
  validates :name, :uniqueness => {:scope => :account_id}

  # def name_under_same_account_must_be_unique
  # 	client_exists = Client.find_by_name(name)
  # 	if client_exists and client_exists.account.id == self.account.id
  # 		errors.add(:name, "Name already taken")
  # 	end
  # end
end
