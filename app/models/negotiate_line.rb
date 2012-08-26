class NegotiateLine < ActiveRecord::Base
  after_save :accept_line_item
  belongs_to :line_item

  def total_price
    if line_price and line_qty
      line_price * line_qty
    else
      0
    end
  end

  def accept_line_item
  	if is_accepted
  		self.line_item.is_accepted = true
  		self.line_item.unit_price = line_price
  		self.line_item.quantity = line_qty
      self.line_item.save
  	end
  end

end
