class ProductsController < ApplicationController

  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true)

    case params.dig(:q, :s)
    when 'price asc'
      @products = @products.order(price: :asc)
    when 'price desc'
      @products = @products.order(price: :desc)
    when 'name asc'
      @products = @products.order(name: :asc)
    else
      @products = @products.order(created_at: :desc)
    end
  end

  def show 
    @product =Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to product_multi_step_index_path(@product)
    else
      flash[:danger] = "Could not create a product"
      redirect_to new_product_path
    end
  end
  
  def edit
    @product=Product.find(params[:id])
  end

  def update
    @product=Product.find(params[:id])
    if @product.update(product_params)
      redirect_to product_multi_step_index_path(@product)
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
    params.require(:product).permit(:name, :description, :price)
  end

end
