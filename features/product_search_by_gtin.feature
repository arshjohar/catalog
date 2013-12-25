Feature: Product Search By GTIN
  In order to see the product details
  As a user
  I should be able to search for a product by GTIN

  Scenario: Successful product search
    Given I am on the product search page
    When I search for a valid GTIN
    Then I should see the product details

  Scenario: Unsuccessful product search
    Given I am on the product search page
    When I search for an invalid GTIN
    Then I should see an error message
