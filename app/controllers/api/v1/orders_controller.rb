module Api
  module V1
    class OrdersController < ApplicationController
      before_action :set_order, only: [:update]

      def update
        if @order.update(order_params)
          render json: { status: 'SUCCESS', message: 'Order status updated successfully.', data: @order }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Failed to update order status.', data: @order.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_order
        @order = Order.find(params[:id])
      end

      def order_params
        params.require(:order).permit(:status)
      end
    end
  end
end
