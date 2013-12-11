FactoryGirl.define do
  factory :product do
    gtin '008527'
    name 'Product 1'
    selling_prices [{seller_name: 'Home Depot', base_price: '$199.99', total_price: '$199.99'},
                    {seller_name: 'Walmart', base_price: '$199.98', total_price: '$199.98'},
                    {seller_name: 'B&H Photo-Video-Audio', base_price: '$199.99', total_price: '$199.99'},
                    {seller_name: 'dealsCube - seaoftools', base_price: '$180.99', total_price: '$180.99'},
                    {seller_name: 'buildingsupplyplus.com', base_price: '$177.99', total_price: '$211.47'},
                    {seller_name: 'Awardpedia.com', base_price: '$199.99', total_price: '$199.99'},
                    {seller_name: 'dropcam.com + Show all 12 - Hide all + Show all 12', base_price: '$199.00', total_price: '$199.00'},
                    {seller_name: 'Brookstone', base_price: '$199.99', total_price: '$209.98'},
                    {seller_name: 'babysupplies', base_price: '$225.34', total_price: '$225.34'},
                    {seller_name: 'Shop.com', base_price: '$199.99', total_price: '$199.99'},
                    {seller_name: 'eBay + Show all 7 - Hide all + Show all 7', base_price: '$219.99', total_price: '$219.99'},
                    {seller_name: 'Datavision', base_price: '$199.00', total_price: '$199.00'},
                    {seller_name: 'Rakuten.com Shopping - Brookstone', base_price: '$200.00',
                     total_price: '$200.00'}]
  end
end
