Feature: Regular Expression Pattern

Background:

Given a typical project directory

Scenario: Features that match the pattern exist

When Cellophane is called with a good regular expression
Then the command should include only the correct files

Scenario: Features that match the pattern do not exist

When Cellophane is called with a bad regular expression
Then the 'No features matching PATTERN were found.' message should display

Scenario: An invalid regular expression is submitted

When Cellophane is called with an invalid regular expression
Then the 'Invalid regular expression provided.' message should display