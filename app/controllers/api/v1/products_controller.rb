module Api
  module V1
    class ProductsController < ApplicationController
      def index
        @products = Product.where('stock > 0')
        render json: @products, status: :ok
      end

      def create
        @product = Product.new(product_params)

        if @product.save
          render json: { status: 'SUCCESS', message: 'Product created successfully', data: @product }, status: :created
        else
          render json: { status: 'ERROR', message: 'Product not created', data: @product.errors }, status: :unprocessable_entity
        end
      end

      def update
        @product = Product.find_by(id: params[:id])
        
        if @product
          if @product.update(product_params)
            render json: { status: 'SUCCESS', message: 'Product updated successfully', data: @product }, status: :ok
          else
            render json: { status: 'ERROR', message: 'Product not updated', data: @product.errors }, status: :unprocessable_entity
          end
        else
          render json: { status: 'ERROR', message: 'Product not found' }, status: :not_found
        end
      end

      def destroy
        @product = Product.find_by(id: params[:id])

        if @product
          @product.destroy
          render json: { status: 'SUCCESS', message: 'Product deleted successfully' }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Product not found' }, status: :not_found
        end
      end

      private

      def product_params
        params.require(:product).permit(:name, :description, :price, :stock, :total_quantity)
      end
    end
  end
end
