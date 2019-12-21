Feature: laying out a web page

  Scenario: wrapping block-level nodes
    Given a web page:
      """
      <div>
        <h1>Firstly.</h1> <h2>Secondly.</h2> <h3>Lastly.</h3>
      </div>
      """
    When I render it in the browser
    Then the text appears over three rows
      | Firstly.     |
      | Secondly.    |
      | Lastly.      |

  Scenario: not wrapping inline nodes
    Given a web page:
      """
      <div>
        <a>Your</a> <a>ad</a> <a>here</a>.
      </div>
      """
    When I render it in the browser
    Then "Youradhere." appears on a single row

  Scenario: wrapping mixed block-level and inline nodes
    Given a web page:
      """
      <div>
        <div>Firstly.</div> <h2>Secondly.</h2>
        <a>Your</a> <a>ad</a>
        <a>here</a> <h3>Lastly.</h3>
      </div>
      """
    When I render it in the browser
    Then the text appears over four rows
      | Firstly.   |
      | Secondly.  |
      | Youradhere |
      | Lastly.    |
