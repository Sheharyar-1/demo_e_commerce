class ProductsController < ApplicationController

  def index
    @products =Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product=Product.new(product_params)
    if @product.save
      redirect_to products_path
    else
      flash[:danger] ="Could not create a product"
      redirect_to new_product_path
    end
  end

  def edit
    @product=Product.find(params[:id])
  end

  def update
    @product=Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path
    else
      flash[:notice]="Could not update product"
      redirect_to edit_product_path
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:notice] = "You have deleted the product."
    redirect_to products_path, status: :see_other
  end

  private
  def product_params
    params.require(:product).permit(:name, :description, :photo, :price, :total_quantity, :stock)
  end
end