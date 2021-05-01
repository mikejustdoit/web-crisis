Feature: browsing the WWW

  Scenario: visiting an address
    When I request an address
    Then the browser visits the address
    And the browser renders the web page
