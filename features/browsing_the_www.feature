Feature: browsing the WWW

  @wip
  Scenario: entering an address
    Given I have launched the web browser
    When I enter an address
    And I click "go"
    Then the browser should visit the address
