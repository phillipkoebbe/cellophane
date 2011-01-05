Feature: Feature paths

Scenario: Standard feature path

Given a standard project directory
When Cellophane is called with ""
Then the command should not include "features"
And the command should not include "-r features/step_definitions"

Scenario: Non-standard feature path

Given a non-standard project directory
And a project specific option file defining the custom paths
When Cellophane is called with ""
Then the command should include "cuke/features"
And the command should include "cuke/steps"