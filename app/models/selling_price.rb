class SellingPrice
  include Mongoid::Document

  field :seller_name, type: String
  field :base_price, type: String
  field :total_price, type: String
end