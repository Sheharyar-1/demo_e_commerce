class OrdersController < ApplicationController
  def index
    @orders = Order.includes(:user).all
  end
end
