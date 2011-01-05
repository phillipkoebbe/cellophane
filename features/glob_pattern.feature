Feature: Glob Pattern

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

Scenario: No files match the pattern

When Cellophane is called with "somebadglobpattern"
Then the message should include "No features matching PATTERN were found"

Scenario: Specific files in feature root

When Cellophane is called with "t*"
Then the command should include "features/two.feature"
And the command should include "features/three.feature"
And the command should not include "features/one.feature"
And the command should not include "features/four.feature"
And the command should not include "features/admin/one.feature"
And the command should not include "features/admin/two.feature"
And the command should not include "features/admin/three.feature"
And the command should not include "features/admin/four.feature"
And the command should not include "features/user/one.feature"
And the command should not include "features/user/two.feature"
And the command should not include "features/user/three.feature"
And the command should not include "features/user/four.feature"

Scenario: Specific files in any subdirectory

When Cellophane is called with "**/t*"
Then the command should include "features/two.feature"
And the command should include "features/three.feature"
And the command should include "features/admin/two.feature"
And the command should include "features/admin/three.feature"
And the command should include "features/user/two.feature"
And the command should include "features/user/three.feature"
And the command should not include "features/one.feature"
And the command should not include "features/four.feature"
And the command should not include "features/admin/one.feature"
And the command should not include "features/admin/four.feature"
And the command should not include "features/user/one.feature"
And the command should not include "features/user/four.feature"

Scenario: All files in a directory

When Cellophane is called with "admin/*"
Then the command should include "features/admin/one.feature"
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

Scenario: Exclude specific files in feature root

When Cellophane is called with "~t*"
Then the command should include "features/one.feature"
And the command should include "features/four.feature"
And the command should include "features/admin/one.feature"
And the command should include "features/admin/two.feature"
And the command should include "features/admin/three.feature"
And the command should include "features/admin/four.feature"
And the command should include "features/user/one.feature"
And the command should include "features/user/two.feature"
And the command should include "features/user/three.feature"
And the command should include "features/user/four.feature"
And the command should not include "features/two.feature"
And the command should not include "features/three.feature"

Scenario: Exclude specific files in any subdirectory

When Cellophane is called with "~**/t*"
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

Scenario: Exclude all files in a directory

When Cellophane is called with "~admin/*"
Then the command should include "features/one.feature"
And the command should include "features/two.feature"
And the command should include "features/three.feature"
And the command should include "features/four.feature"
And the command should include "features/user/one.feature"
And the command should include "features/user/two.feature"
And the command should include "features/user/three.feature"
And the command should include "features/user/four.feature"
And the command should not include "features/admin/one.feature"
And the command should not include "features/admin/two.feature"
And the command should not include "features/admin/three.feature"
And the command should not include "features/admin/four.feature"

Scenario: Include some, exclude others

When Cellophane is called with "admin/*,~admin/three"
Then the command should include "features/admin/one.feature"
And the command should include "features/admin/two.feature"
And the command should include "features/admin/four.feature"
And the command should not include "features/one.feature"
And the command should not include "features/two.feature"
And the command should not include "features/three.feature"
And the command should not include "features/four.feature"
And the command should not include "features/admin/three.feature"
And the command should not include "features/user/one.feature"
And the command should not include "features/user/two.feature"
And the command should not include "features/user/three.feature"
And the command should not include "features/user/four.feature"
