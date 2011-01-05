Feature: Project Options

Scenario: Load project specific options from a file in the project root automatically

Given a standard project directory
And a project specific options file exists in the project root
When Cellophane is called with ""
Then the command should include "--format progress --no-profile"
