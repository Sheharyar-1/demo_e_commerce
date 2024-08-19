class CartsController < ApplicationController
  def show
    @order_items = current_order.order_items
  end

  def placed
    @order = current_order
    if @order.in_progress?
      @order.update(status: :placed)
      redirect_to carts_path, notice: 'Order was successfully placed.'
    else
      redirect_to carts_path, alert: 'Order cannot be placed.'
    end
  end

end
