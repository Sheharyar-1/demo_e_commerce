module ProductsHelper

  def product_price_asc
    products_path(sort: 'price_asc')
  end

  def product_price_dsc
    products_path(sort: 'price_desc')
  end

  def product_name_asc
    products_path(sort: 'name_asc')
  end
end
