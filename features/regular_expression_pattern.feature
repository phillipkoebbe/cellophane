Feature: Regular Expression Pattern

Background:

Given a standard project directory

Scenario: Features that match the pattern exist

When Cellophane is called with "-r (?:one|four)"
Then the command should include "one.feature"
And the command should include "four.feature"
And the command should not include "two.feature"
And the command should not include "three.feature"

Scenario: Features that match the pattern do not exist

When Cellophane is called with "-r somebadregularexpression"
Then the message should include "No features matching PATTERN were found"

Scenario: An invalid regular expression is submitted

When Cellophane is called with "-r "
Then the message should include "Invalid regular expression provided"