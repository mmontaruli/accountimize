class Estimate < ActiveRecord::Base
  after_initialize :default_values
  has_many :line_items, :dependent => :destroy
  belongs_to :client
  
  accepts_nested_attributes_for :line_items, :allow_destroy => true
  
  validates :date, :number, :presence => true
  validates :number, :numericality => {:greater_than_or_equal_to => 1}
  
  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
    
  private
    def default_values
      if Estimate.maximum('number')
        self.number ||= Estimate.maximum('number')+1
      else
        self.number ||= 1000000
      end
    end
  
end
