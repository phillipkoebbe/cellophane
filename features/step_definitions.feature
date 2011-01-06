Feature: Step Definitions

@1
Scenario: Requiring existing step definition

Given a project directory with the following structure
 | type      | path                                   |
 | directory | features                               |
 | directory | features/step_definitions              |
 | file      | features/one.feature                   |
 | file      | features/two.feature                   |
 | file      | features/step_definitions/one_steps.rb |
When Cellophane is called with "one"
Then the command should include "features/one.feature"
And the command should include "-r features/step_definitions/one_steps.rb"

@2
Scenario: Not requiring step definition that doesn't exist

Given a project directory with the following structure
 | type      | path                                   |
 | directory | features                               |
 | directory | features/step_definitions              |
 | file      | features/one.feature                   |
 | file      | features/two.feature                   |
 | file      | features/step_definitions/one_steps.rb |
When Cellophane is called with "two"
Then the command should include "features/two.feature"
And the command should not include "-r features/step_definitions/two_steps.rb"

@3
Scenario: Step definitions nested in feature subdirectories

Given a project directory with the following structure
 | type      | path                                         |
 | directory | features                                     |
 | directory | features/admin                               |
 | directory | features/admin/step_definitions              |
 | file      | features/admin/one.feature                   |
 | file      | features/admin/two.feature                   |
 | file      | features/admin/step_definitions/one_steps.rb |
And a project options file with the following options
 | option                                   |
 | step_path: {nested_in: step_definitions} |
When Cellophane is called with "admin/one"
Then the command should include "features/admin/one.feature"
And the command should include "-r features/admin/step_definitions/one_steps.rb"
