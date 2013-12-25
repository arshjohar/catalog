require 'spec_helper'

describe ProductsController do

  context '#show' do
    it 'should give a product with the given gtin' do
      product = FactoryGirl.create(:product)
      allow(Product).to receive(:find_with_gtin).with(product.gtin).and_return(product)

      get :index, {gtin: product.gtin}

      assigns(:product).should == product
    end

    it 'should show an error message if a product with the given gtin is not found' do
      gtin = '123'
      allow(Product).to receive(:find_with_gtin).with(gtin).and_return(nil)

      get :index, {gtin: gtin}

      expect(flash[:danger]).to eq("Product with GTIN #{gtin} does not exist.")
    end
  end

end
