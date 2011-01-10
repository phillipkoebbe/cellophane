Feature: Tags

@1
Scenario: OR tag

When Cellophane is called with "-t one,two"
Then the command should include "-t @one,@two"

@2
Scenario: NOT tag

When Cellophane is called with "-t one,~two"
Then the command should include "-t @one -t ~@two"

@3
Scenario: AND tag

When Cellophane is called with "-t one,+two"
Then the command should include "-t @one -t @two"

@4
Scenario: Mixed tags in a logical order

When Cellophane is called with "-t one,two,~three,+four"
Then the command should include "-t @one,@two -t @four -t ~@three"

@5
Scenario: Mixed tags not in a logical order

When Cellophane is called with "-t +four,one,~three,two"
Then the command should include "-t @one,@two -t @four -t ~@three"

@6
Scenario: Numeric OR tag ranges

When Cellophane is called with "-t 1-3"
Then the command should include "-t @1,@2,@3"

@7
Scenario: Numeric NOT tag ranges

When Cellophane is called with "-t ~1-3"
Then the command should include "-t ~@1 -t ~@2 -t ~@3"

@8
Scenario: Numeric OR tag range with a NOT in the OR range

When Cellophane is called with "-t 1-3,~2"
Then the command should include "-t @1,@3"

@9
Scenario: Numeric OR tag range with a NOT out of the OR range

When Cellophane is called with "-t 1-3,~slow"
Then the command should include "-t @1,@2,@3 -t ~@slow"
