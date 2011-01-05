Feature: Step Definitions

Background:

Given a project directory with the following structure
 | type      | path                                   |
 | directory | features                               |
 | directory | features/step_definitions              |
 | file      | features/one.feature                   |
 | file      | features/two.feature                   |
 | file      | features/step_definitions/one_steps.rb |

Scenario: Requiring existing step definition

When Cellophane is called with "one"
Then the command should include "features/one.feature"
And the command should include "-r features/step_definitions/one_steps.rb"

Scenario: Not requiring step definition that doesn't exist

When Cellophane is called with "two"
Then the command should include "features/two.feature"
And the command should not include "-r features/step_definitions/two_steps.rb"
