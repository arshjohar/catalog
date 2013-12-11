require 'spec_helper'
describe GoogleShoppingSearcher do

  # Not stubbing private methods since this unit test should check their behaviour as well.
  # Not stubbing out mechanize, as it would make the tests too brittle.
  # Instead of using fakeweb, we may also choose to directly hit google shopping URLs,
  # so that if the HTML structure changes, our tests start failing. Or, maybe have the best
  # of both worlds using vcr.
  context '#get_product_details' do
    before :each do
      stub_request(:get, GoogleShoppingSearcher::URL).to_return(body: File.read(File.dirname(__FILE__) + '/../mock_web_pages/google_shopping_homepage.html'), headers: {'Content-Type' => 'text/html'})
    end

    it 'should return a hash of product details for a specified GTIN from google shopping' do
      stub_request(:get, /^https?\:\/\/www\.google\.com\/search\?/).to_return(body: File.read(File.dirname(__FILE__) + '/../mock_web_pages/search_results_page.html'), headers: {'Content-Type' => 'text/html'})
      stub_request(:get, /^https?\:\/\/www\.google\.com\/shopping\/product\//).to_return(body: File.read(File.dirname(__FILE__) + '/../mock_web_pages/product_details_page.html'), headers: {'Content-Type' => 'text/html'})
      stub_request(:get, /^https?\:\/\/www\.google\.com\/shopping\/product\/.*\/online\?/).to_return(body: File.read(File.dirname(__FILE__) + '/../mock_web_pages/product_details_all_sellers_page.html'), headers: {'Content-Type' => 'text/html'})

      gtin = '00856568003027'

      expect(GoogleShoppingSearcher.new.get_product_details(gtin)).to eq({'gtin' => '00856568003027',
                                                                          'name' => 'Dropcam Pro Wi-Fi Wireless Video Monitoring Camera RY7169',
                                                                          'selling_prices' => [{'seller_name' => 'Home Depot', 'base_price' => '$199.99', 'total_price' => '$199.99'},
                                                                                               {'seller_name' => 'Walmart', 'base_price' => '$199.98', 'total_price' => '$199.98'},
                                                                                               {'seller_name' => 'B&H Photo-Video-Audio', 'base_price' => '$199.99', 'total_price' => '$199.99'},
                                                                                               {'seller_name' => 'dealsCube - seaoftools', 'base_price' => '$180.99', 'total_price' => '$180.99'},
                                                                                               {'seller_name' => 'buildingsupplyplus.com', 'base_price' => '$177.99', 'total_price' => '$211.47'},
                                                                                               {'seller_name' => 'Awardpedia.com', 'base_price' => '$199.99', 'total_price' => '$199.99'},
                                                                                               {'seller_name' => 'dropcam.com', 'base_price' => '$199.00', 'total_price' => '$199.00'},
                                                                                               {'seller_name' => 'Brookstone', 'base_price' => '$199.99', 'total_price' => '$209.98'},
                                                                                               {'seller_name' => 'babysupplies', 'base_price' => '$225.34', 'total_price' => '$225.34'},
                                                                                               {'seller_name' => 'Shop.com', 'base_price' => '$199.99', 'total_price' => '$199.99'},
                                                                                               {'seller_name' => 'eBay', 'base_price' => '$219.99', 'total_price' => '$219.99'},
                                                                                               {'seller_name' => 'Datavision', 'base_price' => '$199.00', 'total_price' => '$199.00'},
                                                                                               {'seller_name' => 'Rakuten.com Shopping - Brookstone', 'base_price' => '$200.00',
                                                                                                'total_price' => '$200.00'}]})
    end

    it 'should return nil if the given product with the specified GTIN does not exist' do
      stub_request(:get, /^https?\:\/\/www\.google\.com\/search\?/).to_return(body: File.read(File.dirname(__FILE__) + '/../mock_web_pages/no_results_page.html'), headers: {'Content-Type' => 'text/html'})

      invalid_gtin = '21908302281931'

      expect(GoogleShoppingSearcher.new.get_product_details(invalid_gtin)).to eq(nil)
    end

    it 'should return nil if the search result is a product with the number on its page, but not as GTIN' do
      stub_request(:get, /^https?\:\/\/www\.google\.com\/search\?/).to_return(body: File.read(File.dirname(__FILE__) + '/../mock_web_pages/irrelevant_results_page.html'), headers: {'Content-Type' => 'text/html'})
      stub_request(:get, /^https?\:\/\/www\.google\.com\/shopping\/product\//).to_return(body: File.read(File.dirname(__FILE__) + '/../mock_web_pages/invalid_product_details_page.html'), headers: {'Content-Type' => 'text/html'})

      invalid_gtin = '1234'

      expect(GoogleShoppingSearcher.new.get_product_details(invalid_gtin)).to eq(nil)
    end

  end
end
