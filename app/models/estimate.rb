class Estimate < ActiveRecord::Base
  after_initialize :default_values
  after_save :accept_lines
  before_validation :default_values
  has_many :line_items, :dependent => :destroy, :order => "position"
  has_many :negotiate_lines, :through => :line_items
  has_one :invoice_schedule, :dependent => :destroy
  belongs_to :client

  accepts_nested_attributes_for :line_items, :allow_destroy => true

  validates :date, :number, :client_id, :send_to_contact, :presence => true
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
      self.number = self.client.account.estimates.default_number
    end
  end

  def accept_lines
    if self.is_accepted
      self.line_items.each do |line_item|
        line_item.is_accepted = true
        line_item.save
      end
    end
  end

end
