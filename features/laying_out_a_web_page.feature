Feature: laying out a web page

  Scenario: block-level nodes
    Given the HTML input:
      """
      <div>
        <h1>Firstly.</h1> <h2>Secondly.</h2> <h3>Lastly.</h3>
      </div>
      """
    When I render it in the browser
    Then each element appears below its predecessor
    And their parent fits them all heightwise

  Scenario: inline nodes
    Given the HTML input:
      """
      <div>
        <a>Your</a> <a>ad</a> <a>here</a>.
      </div>
      """
    When I render it in the browser
    Then each element appears to the right of its predecessor
    And their parent fits them all widthwise

  @wip
  Scenario: mixed block-level and inline nodes
    Given the HTML input:
      """
      <div>
        <div>Firstly.</div> <h2>Secondly.</h2>
        <a>Your</a> <a>ad</a>
        <a>here</a> <h3>Lastly.</h3>
      </div>
      """
    When I render it in the browser
    Then the elements appear over four rows
    And their parent fits the longest row of chilren
