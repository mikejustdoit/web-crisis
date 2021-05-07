Feature: browsing the WWW

  Scenario: visiting an address
    When I request an address
    Then the browser visits the address
    And the browser renders the web page

  Scenario: scrolling down a page
    Given I'm on the page "https://en.wikipedia.org/wiki/Scrolling"
    And I can see the heading "Scrolling"
    But I cannot see the heading "UI paradigms"
    When I scroll down the page
    Then I can see the heading "UI paradigms"
    But I cannot see the heading "Scrolling"
