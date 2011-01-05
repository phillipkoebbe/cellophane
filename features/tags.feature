Feature: Tags

Background:

Scenario: Or tag

When Cellophane is called with "-t one,two"
Then the command should include "-t @one,@two"

Scenario: Not tag

When Cellophane is called with "-t one,~two"
Then the command should include "-t @one -t ~@two"

Scenario: And tag

When Cellophane is called with "-t one,+two"
Then the command should include "-t @one -t @two"

Scenario: Mixed tags in a logical order

When Cellophane is called with "-t one,two,~three,+four"
Then the command should include "-t @one,@two -t @four -t ~@three"

Scenario: Mixed tags not in a logical order

When Cellophane is called with "-t +four,one,~three,two"
Then the command should include "-t @one,@two -t @four -t ~@three"