Feature: Feature paths

Scenario: Standard feature path

Given a project directory with the following structure
 | type      | path                      |
 | directory | features                  |
 | directory | features/step_definitions |
When Cellophane is called with ""
Then the command should not include "features"
And the command should not include "-r features/step_definitions"

Scenario: Non-standard feature path

Given a project directory with the following structure
 | type      | path          |
 | directory | cuke/features |
 | directory | cuke/steps    |
And a project options file with the following options
 | option                           |
 | :feature_path => 'cuke/features' |
 | :step_path => 'cuke/steps'       |
 | :requires => ['cuke/support']    |
When Cellophane is called with ""
Then the command should include "cuke/features"
And the command should include "-r cuke/steps"
And the command should include "-r cuke/support"