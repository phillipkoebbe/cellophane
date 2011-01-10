Feature: Project Options

@1
Scenario: Load project specific options from a file

Given a project directory with the following structure
 | type      | path                      |
 | directory | features                  |
 | directory | features/step_definitions |
And a project options file with the following options
 | option                                   |
 | cucumber: --format progress --no-profile |
When Cellophane is called with ""
Then the command should include "--format progress --no-profile"

@2
Scenario: Override with command line

Given a project directory with the following structure
 | type      | path                      |
 | directory | features                  |
 | directory | features/step_definitions |
And a project options file with the following options
 | option                                   |
 | cucumber: --format progress --no-profile |
When Cellophane is called with "-c --format=pretty"
Then the command should include "--format=pretty"
And the command should not include "progress"
And the command should not include "--no-profile"
