module Api
  module V1
    class ProductsController < ApplicationController
      def index
        @products = Product.where('stock > 0')
        render json: @products, status: :ok
      end
    end
  end
end
