module Pages
  class HomePage < SitePrism::Page
    set_url '/'

    element :product_search_gtin_link, 'a#product-search-gtin'
  end
end
