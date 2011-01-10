Feature: Cuke Command

@1
Scenario: Default to cucumber

When Cellophane is called with ""
Then the command should include "cucumber"

@2
Scenario Outline: Override from project options

Given a project options file with the following options
 | option                  |
 | cuke_command: <command> |
When Cellophane is called with ""
Then the command should include "<command>"

Scenarios:
| command               |
| bundler exec cucumber |
| script/cucumber       |