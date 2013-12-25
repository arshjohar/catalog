Given /^I am on the homepage$/ do
  @homepage = Pages::HomePage.new
  @homepage.load
end

When /^I click on the product search link$/ do
  @homepage.product_search_gtin_link.click
end

Then /^I should be redirected to the product search page$/ do
  Pages::ProductSearchPage.new.should be_displayed
end
