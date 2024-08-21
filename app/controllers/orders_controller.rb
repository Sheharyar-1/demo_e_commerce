class OrdersController < ApplicationController
  load_and_authorize_resource
  def index
    @orders = Order.paginate(page: params[:page], per_page: 8)
  end

  def update
    @order = Order.find(params[:id])
    authorize! :update, @order
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
