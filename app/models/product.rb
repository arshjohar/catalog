class Product
  include Mongoid::Document

  # Using a hash to keep it extensible later on for including multiple sources.
  PRODUCT_SOURCES = { google_shopping: GoogleShoppingSearcher.new }

  field :gtin, type: String
  field :name, type: String
  embeds_many :selling_prices

  validates_uniqueness_of :gtin
  validates_presence_of :gtin, :name, :selling_prices

  index({gtin: 1}, {unique: true, background: true})

  def self.find_with_gtin(gtin)
    product_details = Product.find_by(gtin: gtin)
    return product_details if product_details
    product_details = PRODUCT_SOURCES[:google_shopping].get_product_details(gtin)
    Product.create(product_details)
    product_details
  end
end
