class Order < ApplicationRecord
  has_many :order_items
  before_save :set_subtotal

  def subtotal
    order_items.collect do |order_item|
      if order_item.valid? && order_item.unit_price && order_item.quantity
        order_item.unit_price * order_item.quantity
      else
        0
      end
    end.sum
  end
  
  private
  
  def set_subtotal
    self[:subtotal] = subtotal
  end
end
