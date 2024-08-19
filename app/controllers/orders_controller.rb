class OrdersController < ApplicationController
  def index
    @orders = Order.includes(:user).all
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to orders_path, notice: 'Order status updated successfully.'
    else
      redirect_to orders_path, alert: 'Failed to update order status.'
    end
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end
end
