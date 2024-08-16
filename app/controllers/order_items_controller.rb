class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:update, :destroy]

  def create
    @order = current_order
    @order_item = @order.order_items.new(order_item_params)
    @product = @order_item.product
  
    if @order_item.quantity > @product.stock
      flash[:alert] = "Quantity exceeds available stock (#{@product.stock})."
      redirect_to product_path(@product, order_item_product_id: @order_item.product_id)

    else
      @order.save
      @product.update(stock: @product.stock - @order_item.quantity)
      session[:order_id] = @order.id
      flash[:notice] = 'Item added to cart.'
      redirect_to product_path(@product, order_item_product_id: @order_item.product_id)
    end
  end
  
  def update
    @product = @order_item.product
    updated_quantity = order_item_params[:quantity].to_i
    previous_quantity = @order_item.quantity
    difference = updated_quantity - previous_quantity
  
    if difference > @product.stock
      flash[:alert] = "Quantity exceeds available stock (#{@product.stock})."
      redirect_to carts_path
    else
      if @order_item.update(order_item_params)
        @product.update(stock: @product.stock - difference)
        flash[:notice] = 'Order item updated successfully.'
      else
        flash[:alert] = 'Failed to update order item.'
      end
      redirect_to carts_path
    end
  end
  
  def destroy
    @product = @order_item.product
    @product.update(stock: @product.stock + @order_item.quantity)
    @order_item.destroy
    @order_items = @order.order_items
  end

  private

  def set_order_item
    @order= current_order
    @order_item = @order.order_items.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:product_id, :quantity)
  end
end
