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

@4
Scenario: Automatically loading shared_steps.rb in simple project

Given a project directory with the following structure
 | type      | path                                      |
 | directory | features                                  |
 | directory | features/step_definitions                 |
 | file      | features/one.feature                      |
 | file      | features/two.feature                      |
 | file      | features/step_definitions/one_steps.rb    |
 | file      | features/step_definitions/shared_steps.rb |
When Cellophane is called with "one"
Then the command should include "features/one.feature"
And the command should include "-r features/step_definitions/one_steps.rb"
And the command should include "-r features/step_definitions/shared_steps.rb"

@5
Scenario: Automatically loading shared_steps.rb in complex project

Given a project directory with the following structure
 | type      | path                                            |
 | directory | features                                        |
 | directory | features/admin                                  |
 | directory | features/user                                   |
 | directory | features/step_definitions                       |
 | directory | features/step_definitions/admin                 |
 | directory | features/step_definitions/user                  |
 | file      | features/admin/one.feature                      |
 | file      | features/admin/two.feature                      |
 | file      | features/user/one.feature                       |
 | file      | features/user/two.feature                       |
 | file      | features/step_definitions/shared_steps.rb       |
 | file      | features/step_definitions/admin/one_steps.rb    |
 | file      | features/step_definitions/admin/shared_steps.rb |
 | file      | features/step_definitions/user/one_steps.rb     |
 | file      | features/step_definitions/user/shared_steps.rb  |
When Cellophane is called with "admin/one"
Then the command should include "features/admin/one.feature"
And the command should include "-r features/step_definitions/admin/one_steps.rb"
And the command should include "-r features/step_definitions/shared_steps.rb"
And the command should include "-r features/step_definitions/admin/shared_steps.rb"
And the command should not include "-r features/step_definitions/user/one_steps.rb"
And the command should not include "-r features/step_definitions/user/shared_steps.rb"

@6
Scenario: Automatically loading shared_steps.rb when steps are nested

Given a project directory with the following structure
 | type      | path                                            |
 | directory | features                                        |
 | directory | features/admin                                  |
 | directory | features/admin/step_definitions                 |
 | file      | features/admin/one.feature                      |
 | file      | features/admin/two.feature                      |
 | file      | features/admin/step_definitions/one_steps.rb    |
 | file      | features/admin/step_definitions/shared_steps.rb |
And a project options file with the following options
 | option                                   |
 | step_path: {nested_in: step_definitions} |
When Cellophane is called with "admin/one"
Then the command should include "features/admin/one.feature"
And the command should include "-r features/admin/step_definitions/one_steps.rb"
And the command should include "-r features/admin/step_definitions/shared_steps.rb"

@7
Scenario: Automatically loading shared steps in files named differently

Given a project directory with the following structure
 | type      | path                                      |
 | directory | features                                  |
 | directory | features/step_definitions                 |
 | file      | features/one.feature                      |
 | file      | features/two.feature                      |
 | file      | features/step_definitions/one_steps.rb    |
 | file      | features/step_definitions/global_steps.rb |
And a project options file with the following options
 | option         |
 | shared: global |
When Cellophane is called with "one"
Then the command should include "features/one.feature"
And the command should include "-r features/step_definitions/one_steps.rb"
And the command should include "-r features/step_definitions/global_steps.rb"

@8
Scenario: Turning off automatically loading shared steps

Given a project directory with the following structure
 | type      | path                                      |
 | directory | features                                  |
 | directory | features/step_definitions                 |
 | file      | features/one.feature                      |
 | file      | features/two.feature                      |
 | file      | features/step_definitions/one_steps.rb    |
 | file      | features/step_definitions/shared_steps.rb |
And a project options file with the following options
 | option        |
 | shared: false |
When Cellophane is called with "one"
Then the command should include "features/one.feature"
And the command should include "-r features/step_definitions/one_steps.rb"
And the command should not include "-r features/step_definitions/shared_steps.rb"
