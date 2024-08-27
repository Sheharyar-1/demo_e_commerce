module Api
  module V1
    class OrderItemsController < ApplicationController

      def create
        @user=User.find(params[:user_id])
        @order = @user.order.new
        @order_item = @order.order_items.new(order_item_params)
        @product = @order_item.product

        if @order_item.quantity > @product.stock
          render json: { status: 'ERROR', message: "Quantity exceeds available stock (#{@product.stock})." }, status: :unprocessable_entity
        else
          if @order.save
            @product.update(stock: @product.stock - @order_item.quantity)
            session[:order_id] = @order.id
            render json: { status: 'SUCCESS', message: 'Item added to cart.', data: @order_item }, status: :created
          else
            render json: { status: 'ERROR', message: 'Order not saved.', data: @order.errors }, status: :unprocessable_entity
          end
        end
      end

      def update
        @user = User.find(params[:user_id])
        @order = @user.order.find(params[:order_id])
        @order_item = @order.order_items.find(params[:id])
        @product = @order_item.product
        updated_quantity = order_item_params[:quantity].to_i
        previous_quantity = @order_item.quantity
        difference = updated_quantity - previous_quantity

        if difference > @product.stock
          render json: { status: 'ERROR', message: "Quantity exceeds available stock (#{@product.stock})." }, status: :unprocessable_entity
        else
          if @order_item.update(order_item_params)
            @product.update(stock: @product.stock - difference)
            render json: { status: 'SUCCESS', message: 'Order item updated successfully.', data: @order_item }, status: :ok
          else
            render json: { status: 'ERROR', message: 'Failed to update order item.', data: @order_item.errors }, status: :unprocessable_entity
          end
        end
      end

      def destroy
        @user = User.find(params[:user_id])
        @order = @user.order.find(params[:order_id])
        @order_item = @order.order_items.find(params[:id])
        @product = @order_item.product
        @product.update(stock: @product.stock + @order_item.quantity)
        @order_item.destroy
        render json: { status: 'SUCCESS', message: 'Order item removed from cart.' }, status: :ok
      end


      private

      def set_order_item
        @order = current_order
        @order_item = @order.order_items.find(params[:id])
      end

      def order_item_params
        params.require(:order_item).permit(:product_id, :quantity)
      end
    end
  end
end
