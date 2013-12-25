module Pages
  class ProductSearchPage < SitePrism::Page
    set_url '/products'
    set_url_matcher /\/products\??.*/

    element :error_message, 'div.alert.alert-danger'
    element :search_field, "input[name='gtin']"
    element :search_button, 'input#submit-gtin'
    element :product_name, 'h3.product-name'
    element :gtin, 'span.product-gtin-val'

    element :seller_listing, '#seller-table'
  end
end
