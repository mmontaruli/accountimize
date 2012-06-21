class Invoice < ActiveRecord::Base
  after_initialize :default_values
  before_validation :default_values
  belongs_to :client

  validates :date, :number, :client_id, :presence => true
  validates :number, :numericality => {:greater_than_or_equal_to => 1}

  def self.default_number
    new_number = self.maximum('number')
    new_number ? new_number+1 : 1000000
  end

  private
  def default_values
    if !self.number && self.client && self.client.account
      self.number = self.client.account.invoices.default_number
    end
  end

end
