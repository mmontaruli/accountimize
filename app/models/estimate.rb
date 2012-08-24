class Estimate < ActiveRecord::Base
  after_initialize :default_values
  #after_initialize :accept_lines
  #before_save :accept_lines
  #after_save :accept_lines
  #after_save :accept_estimate
  before_validation :default_values
  has_many :line_items, :dependent => :destroy
  has_many :negotiate_lines, :through => :line_items
  has_one :invoice_schedule, :dependent => :destroy
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
      self.number = self.client.account.estimates.default_number
    end
  end
  def accept_lines
    if self.is_accepted
      self.line_items.each do |line_item|
        line_item.is_accepted = true
      end
    end
    #this is causing issues in testing...
    #try again in doing this in the LineItem model...
    #maybe something like before_save LineItem.accept_lines
    # self.line_items.each do |line_item|
    #   line_item.negotiate_lines.each do |negotiate_line|
    #     if negotiate_line.is_accepted
    #       line_item.is_accepted = true
    #       #notworking#line_item.quantity = negotiate_line.line_qty
    #       #notworking#line_item.unit_price = negotiate_line.line_price
    #     end
    #   end
    # end
  end

end
