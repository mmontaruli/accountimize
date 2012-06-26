class NegotiateLine < ActiveRecord::Base
  belongs_to :line_item

  def total_price
    if line_price and line_qty
      line_price * line_qty
    else
      0
    end
  end

end
