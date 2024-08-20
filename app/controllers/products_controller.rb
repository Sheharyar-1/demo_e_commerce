class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).paginate(page: params[:page], per_page: 5)

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
    @order_item =current_order.order_items.new  if current_user
    authorize! :read, @product
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
  
  def edit; end

  def update
    if @product.update(product_params)
      redirect_to product_multi_step_index_path(@product)
    else
      flash[:notice]="Could not update product"
      redirect_to edit_product_path
    end
  end

  def destroy
    @product.destroy
    flash[:notice] = "You have deleted the product."
    redirect_to products_path, status: :see_other
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price)
  end
end
