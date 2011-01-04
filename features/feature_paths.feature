Feature: Feature paths

Scenario: Standard feature path

Given a standard project directory
When Cellophane is called with no arguments
Then the command should not include the feature path

Scenario: Non-standard feature path

Given a non-standard project directory
And a project specific option file defining the custom paths
When Cellophane is called with no arguments
Then the command should include the feature path