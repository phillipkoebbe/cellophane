Feature: Regular Expression Pattern

Background:

Given a project directory with the following structure
 | type      | path                         |
 | directory | features                     |
 | directory | features/admin               |
 | directory | features/user                |
 | file      | features/one.feature         |
 | file      | features/two.feature         |
 | file      | features/three.feature       |
 | file      | features/four.feature        |
 | file      | features/admin/one.feature   |
 | file      | features/admin/two.feature   |
 | file      | features/admin/three.feature |
 | file      | features/admin/four.feature  |
 | file      | features/user/one.feature    |
 | file      | features/user/two.feature    |
 | file      | features/user/three.feature  |
 | file      | features/user/four.feature   |

Scenario: Features that match the pattern do not exist

When Cellophane is called with "-r somebadregularexpression"
Then the message should include "No features matching PATTERN were found"

Scenario: An invalid regular expression is submitted

When Cellophane is called with "-r "
Then the message should include "Invalid regular expression provided"

Scenario: Specific files

When Cellophane is called with "-r (?:one|four)"
Then the command should include "features/one.feature"
And the command should include "features/four.feature"
And the command should include "features/admin/one.feature"
And the command should include "features/admin/four.feature"
And the command should include "features/user/one.feature"
And the command should include "features/user/four.feature"
And the command should not include "features/two.feature"
And the command should not include "features/three.feature"
And the command should not include "features/admin/two.feature"
And the command should not include "features/admin/three.feature"
And the command should not include "features/user/two.feature"
And the command should not include "features/user/three.feature"

Scenario: All files in a directory

When Cellophane is called with "-r \/admin\/"
And the command should include "features/admin/one.feature"
And the command should include "features/admin/two.feature"
And the command should include "features/admin/three.feature"
And the command should include "features/admin/four.feature"
And the command should not include "features/one.feature"
And the command should not include "features/two.feature"
And the command should not include "features/three.feature"
And the command should not include "features/four.feature"
And the command should not include "features/user/one.feature"
And the command should not include "features/user/two.feature"
And the command should not include "features/user/three.feature"
And the command should not include "features/user/four.feature"
