class Invoice < ActiveRecord::Base
  after_initialize :default_values
  before_validation :default_values
  has_many :line_items, :dependent => :destroy
  has_one :invoice_milestone
  belongs_to :client

  accepts_nested_attributes_for :line_items, :allow_destroy => true

  validates :date, :number, :client_id, :presence => true
  validates :number, :numericality => {:greater_than_or_equal_to => 1}

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

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
