require 'spec_helper'

describe ProductsController do

  context '#index' do
    it 'should give a product with the given gtin' do
      valid_gtin = '1234'
      product = double(Product)
      allow(Product).to receive(:find_with_gtin).with(valid_gtin).and_return(product)

      get :index, {gtin: valid_gtin}

      assigns(:product).should == product
      expect(response).to render_template('index')
    end

    it 'should show an error message if a product with the given gtin is not found' do
      invalid_gtin = 'invalid'
      allow(Product).to receive(:find_with_gtin).with(invalid_gtin).and_return(nil)

      get :index, {gtin: invalid_gtin}

      expect(flash[:danger]).to eq("Product with GTIN #{invalid_gtin} does not exist.")
      expect(response).to render_template('index')
    end
  end

end
