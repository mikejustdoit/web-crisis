Feature: browsing the WWW

  Scenario: visiting an address
    When I request an address
    Then the browser should visit the address
    And the browser should render the web page
