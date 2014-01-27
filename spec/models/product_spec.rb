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
    it 'should return a product with the given gtin and not scrape if it already exists in the database' do
      persisted_product = FactoryGirl.create(:product)
      expect_any_instance_of(GoogleShoppingSearcher).not_to receive(:get_product_details)

      expect(Product.find_with_gtin(persisted_product.gtin)).to eq(persisted_product)
    end

    it 'should scrape Google Shopping to search the product and persist it if it does not exist in the database' do
      #product_gtin = '12334232'
      new_product = FactoryGirl.build(:product)
      #new_product_details = { 'gtin' => product_gtin, 'name' => 'Product', 'selling_prices' => [{'base_price' => '$18',
      #                                                                                          'seller_name' => 'Seller',
      #                                                                                          'total_price' => '$18'}]}
      expect_any_instance_of(GoogleShoppingSearcher).to receive(:get_product_details).with(new_product.gtin)
                                                        .and_return(new_product.as_json)

      expect(Product.find_with_gtin(new_product.gtin)).to eq(new_product)
      expect(Product.find_by(gtin: new_product.gtin)).to eq(new_product)
    end

    it 'should return nil if the product does exists neither in the database nor google shopping' do
      allow_any_instance_of(GoogleShoppingSearcher).to receive(:get_product_details).and_return(nil)

      expect(Product.find_with_gtin('invalid')).to eq(nil)
    end
  end
end
