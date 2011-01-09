Feature: Tags

Scenario: OR tag

When Cellophane is called with "-t one,two"
Then the command should include "-t @one,@two"

Scenario: NOT tag

When Cellophane is called with "-t one,~two"
Then the command should include "-t @one -t ~@two"

Scenario: AND tag

When Cellophane is called with "-t one,+two"
Then the command should include "-t @one -t @two"

Scenario: Mixed tags in a logical order

When Cellophane is called with "-t one,two,~three,+four"
Then the command should include "-t @one,@two -t @four -t ~@three"

Scenario: Mixed tags not in a logical order

When Cellophane is called with "-t +four,one,~three,two"
Then the command should include "-t @one,@two -t @four -t ~@three"

Scenario: Numeric OR tag ranges

When Cellophane is called with "-t 1-3"
Then the command should include "-t @1,@2,@3"

Scenario: Numeric NOT tag ranges

When Cellophane is called with "-t ~1-3"
Then the command should include "-t ~@1 -t ~@2 -t ~@3"

@focus
Scenario: Numeric OR tag range with a NOT

When Cellophane is called with "-t 1-3,~2"
Then the command should include "-t @1,@3"
