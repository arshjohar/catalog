require 'spec_helper'

describe Product do

  it { should have_fields(:gtin, :name).of_type(String) }

  it { should embed_many(:selling_prices) }

  it { should validate_uniqueness_of(:gtin) }

  it { should validate_presence_of(:gtin) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:selling_prices) }

  #Cannot use this spec as of now due to an issue in mongoid-rspec, wherein index_options method has been changed to index_specifications
  #it { should have_index_for(gtin: 1).with_options(unique: true, background: true) }

  #I prefer using method names in context as its easier to find specs related to a method
  context '#find_with_gtin' do
    before :each do
      @product = FactoryGirl.create(:product)
    end

    it 'should return a product with the given gtin if it already exists in the database' do
      expect(Product).to receive(:find_by).with(gtin: @product.gtin).and_return(@product)
      expect_any_instance_of(GoogleShoppingSearcher).not_to receive(:get_product_details)
      expect(Product).not_to receive(:save)

      expect(Product.find_with_gtin(@product.gtin)).to eq(@product)
    end

    it 'should scrape Google Shopping to search the product if it does not exist in the database' do
      expect(Product).to receive(:find_by).with(gtin: @product.gtin).and_return(nil)
      expect(Product).to receive(:create).and_return(true)
      allow_any_instance_of(GoogleShoppingSearcher).to receive(:get_product_details).with(@product.gtin).and_return(@product)

      expect(Product.find_with_gtin(@product.gtin)).to eq(@product)
    end

    it 'should return nil if the product does not exist either in the database or google shopping' do
      expect(Product).to receive(:find_by).and_return(nil)
      allow_any_instance_of(GoogleShoppingSearcher).to receive(:get_product_details).with(@product.gtin).and_return(nil)
      expect(Product).not_to receive(:save)

      expect(Product.find_with_gtin(@product.gtin)).to eq(nil)
    end
  end
end
