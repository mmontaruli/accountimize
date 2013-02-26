class Account < ActiveRecord::Base
  has_many :clients, :dependent => :destroy, :inverse_of => :account
  has_many :estimates, :through => :clients
  has_many :users, :through => :clients
  has_many :invoices, :through => :clients
  before_validation :generate_subdomain

  accepts_nested_attributes_for :clients, :allow_destroy => true

  validates :name, :presence => true
  validates :subdomain, :presence => true, :uniqueness => true
  validates :subdomain, :format => { :with =>/^[a-zA-Z0-9]+$/, :message => "can only have letters and numbers" }

	private

	def generate_subdomain
		sub = self.name.gsub(/[\W_]/, "").downcase
		sub = create_unique_sub(sub)
		self.subdomain = sub
	end

	def sub_exists(sub)
		return !Account.find_by_subdomain(sub).nil?
	end

	def create_unique_sub(sub)
		if sub_exists(sub)
			i = 0
			while sub_exists("#{sub}#{i}") == true
				i = i + 1
			end
			sub = "#{sub}#{i}"
		end
		return sub
	end

end
