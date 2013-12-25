Feature: Homepage navigation
  In order to use the features of the website
  As a user
  I should be able to navigate to various pages from the homepage

  Scenario: Navigation to product search page
    Given I am on the homepage
    When I click on the product search link
    Then I should be redirected to the product search page
