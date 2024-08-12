class MultiStepController < ApplicationController
  include Wicked::Wizard

  steps :stock, :image

  def show
    @product=Product.find(params[:product_id])
    render_wizard
  end

  def update
    @product = Product.find(params[:product_id])
  
    case step
    when :stock
      @product.assign_attributes(product_params_stock)
    when :image
      @product.assign_attributes(product_params_image)
    end
  
    render_wizard @product
  end
  
  private
  
  def product_params_stock
    params.require(:product).permit(:total_quantity, :stock)
  end
  
  def product_params_image
    params.require(:product).permit(:photo)
  end  

end
