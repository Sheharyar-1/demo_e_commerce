class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user
  before_save :set_subtotal
  enum status: {in_progress: 0, placed: 1, dispatched: 2, delivered: 3, cancelled: 4}

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
