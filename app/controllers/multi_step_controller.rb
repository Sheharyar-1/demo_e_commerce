class MultiStepController < ApplicationController
  include Wicked::Wizard
  before_action :set_product, only: [:show, :update]
  steps :stock, :image

  def show
    render_wizard
  end

  def update
   
    case step
    when :stock
      @product.assign_attributes(product_params_stock)
    when :image
      @product.assign_attributes(product_params_image)
    end
  
    render_wizard @product
  end
  
  private

  def set_product
    @product = Product.find(params[:product_id])
  end
  
  def product_params_stock
    params.require(:product).permit(:total_quantity, :stock)
  end
  
  def product_params_image
    params.require(:product).permit(:photo)
  end

  def finish_wizard_path
    product_path(@product)
  end

end
