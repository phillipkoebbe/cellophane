Feature: Project Options

Background:

Given a typical project directory

Scenario: Load project specific options from a file in the project root automatically

Given a project specific options file exists in the project root
When Cellophane is called with no arguments
Then the command should include the project specific options
