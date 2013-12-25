Given /^I am on the product search page$/ do
  @product_search_page = Pages::ProductSearchPage.new
  @product_search_page.load
end

# Doing an actual HTTP call rather than stubbing it out, so that these tests break when the page layouts in the external
# website change. This scenario is more important than these tests not running when there is no internet connectivity.
# Even better, we may use a fallback mechanism wherein if no connection is present, it may start using WebMock.
When /^I search for a valid GTIN$/ do
  @valid_gtin = '00744476505385'
  @product_search_page.search_field.set(@valid_gtin)
  @product_search_page.search_button.click
end

When /^I search for an invalid GTIN$/ do
  @invalid_gtin = '1223234234234'
  @product_search_page.search_field.set(@invalid_gtin)
  @product_search_page.search_button.click
end

# Not checking the values of gtin and seller listings here since this brings in live data, which may change.
# Moreover, this data has already been asserted upon in unit tests.
Then /^I should see the product details$/ do
  @product_search_page.should be_displayed
  @product_search_page.should have_gtin
  @product_search_page.should have_product_name
  @product_search_page.should have_seller_listing
end

Then /^I should see an error message$/ do
  @product_search_page.should be_displayed
  @product_search_page.should have_error_message
  @product_search_page.error_message.text.should eq("Product with GTIN #{@invalid_gtin} does not exist.")
end
