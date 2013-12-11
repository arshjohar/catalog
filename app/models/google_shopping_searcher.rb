class GoogleShoppingSearcher

  URL = 'http://www.google.com/shopping'
  DOM_CLASS_SELECTORS = {search_form: 'gbqf',
                         search_field: 'q',
                         # Did not use the link, as it did not have a DOM class or id. Image link had a class, and seems more likely to remain constant.
                         search_results_product_details_image_link: 'psliimg',
                         all_stores_link: 'pag-detail-link'}

  DOM_CSS_SELECTORS = {product_name: '#product-name',
                       sellers_table: 'table.os-main-table#os-sellers-table',
                       seller_names: 'td.os-seller-name span.os-seller-name-primary',
                       seller_base_prices: 'td.os-price-col span.os-base_price',
                       seller_total_prices: 'td.os-total-col',
                       gtin: 'span.specs-value'}

  def get_product_details(gtin)
    Mechanize.start do |scraping_agent|
      # Changing the user-agent since many websites are not crawler-friendly.
      # The dom id's and classes were varying with different user-agents,and this seems to be the most friendly user-agent.
      # With this user-agent, atleast the searching of appropriate links became easier. And, I was able to select ones
      # where I expect the least change.
      scraping_agent.user_agent_alias = 'Windows Chrome'
      search_results_page = search_by_gtin(gtin, scraping_agent)
      product_all_sellers_page = product_details_page(search_results_page, gtin)
      return (product_all_sellers_page ? extract_product_details(gtin, product_all_sellers_page) : nil)
    end
  end

  private
  def search_by_gtin(gtin, scraping_agent)
    # namespacing the URL constant in order to make it clear, as every other library has classes and constants by this name.
    homepage = scraping_agent.get(GoogleShoppingSearcher::URL)
    search_form = homepage.form_with(name: DOM_CLASS_SELECTORS[:search_form])
    search_form.field_with(name: DOM_CLASS_SELECTORS[:search_field]).value = gtin
    scraping_agent.submit(search_form)
  end

  def product_details_page(search_results_page, gtin)
    initial_product_details_page = click_search_result(search_results_page, gtin)
    if initial_product_details_page
      return include_all_sellers(initial_product_details_page) if initial_product_details_page.search(DOM_CSS_SELECTORS[:gtin]).map(&:text).last == gtin
    end
    nil
  end

  def click_search_result(search_results_page, gtin)
    search_results_page.link_with(dom_class: DOM_CLASS_SELECTORS[:search_results_product_details_image_link], href: /#{gtin}/).try(:click)
  end

  def include_all_sellers(initial_product_details_page)
    initial_product_details_page.link_with(dom_class: DOM_CLASS_SELECTORS[:all_stores_link]).try(:click) || initial_product_details_page
  end

  def extract_product_details(gtin, product_all_sellers_page)
    product_name = product_all_sellers_page.search(DOM_CSS_SELECTORS[:product_name]).text.strip
    seller_details_table = product_all_sellers_page.search(DOM_CSS_SELECTORS[:sellers_table])
    seller_names = seller_details_table.search(DOM_CSS_SELECTORS[:seller_names]).map(&:text).map(&:squish)
    seller_base_prices = seller_details_table.search(DOM_CSS_SELECTORS[:seller_base_prices]).map(&:text).map(&:strip)
    seller_total_prices = seller_details_table.search(DOM_CSS_SELECTORS[:seller_total_prices]).map(&:text).map(&:strip)

    selling_prices = []
    seller_names.each_with_index do |seller_name, index|
      selling_prices << {'seller_name' => seller_name, 'base_price' => seller_base_prices[index], 'total_price' => seller_total_prices[index]}
    end
    {'gtin' => gtin, 'name' => product_name, 'selling_prices' => selling_prices}
  end

end
