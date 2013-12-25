class ProductsController < ApplicationController

  def index
    if params[:gtin]
      @product = Product.find_with_gtin(params[:gtin])
      flash.now[:danger] = "Product with GTIN #{params[:gtin]} does not exist." unless @product
    end
  end

end
