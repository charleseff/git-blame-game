Feature: Other scenarios

  Scenario: Getting help
    When I run `bin/git-blame-game --help`
    Then it should pass with:
    """
    Usage: git-blame-game [options] path/to/filename
    """

  Scenario: Without a filepath:
    When I run `bin/git-blame-game`
    Then it should fail with:
    """
    missing argument: You must specify a path to a file
    """

  Scenario: Specifying a file that doesn't exist:
    When I run `bin/git-blame-game file/that/doesnt/exist.rb`
    Then it should fail with:
    """
    fatal: no such path file/that/doesnt/exist.rb in HEAD
    """

  Scenario: Invalid input on git blame view:
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    And I type "foobar"
    Then I should see:
    """
      Invalid input.  Enter:
        - the line number from the above list (from 1 to 5) you are git blaming.
        - the sha to git blame chain into.
        - 'v' to view the git blame again

      (h for help) >
    """

  Scenario: Invalid input on git show view:
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    And I type "3"
    And I type "blah"
    Then I should see:
    """
      Invalid input.  Enter:
        - 'q' to quit, if you have found the offending commit
        - the number from the above list (from 1 to 1) of the file to git blame chain into.
        - the filepath to git blame chain into.
        - 's' to git blame chain into the 'same' file as before
        - 'v' to view the git show again

      (h for help) >
    """

  Scenario: With a SHA:
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game blah.rb --sha=63b41ee41653991aa00ce9687e3f403efd4c29d4` interactively
    Then I should see:
    """
      ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 1) def add_4(x)
      63b41ee4 (Bob Barker 2012-01-14 14:46:53 -0800 2)   x + 5
      ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 3) end
      ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 4)
      ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 5) puts add_4(9) # should be 13
    """

  Scenario: Entering the SHA instead of the number
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    When I type "5087eab5"
    Then I should see:
    """
      commit 5087eab56af9b0901a1b190de14f29867307c140
      Author: Danny Dover <developers+danny@foo.com>
      Date:   Sat Jan 14 14:50:06 2012 -0800

          I like y's better

      diff --git a/add.rb b/add.rb
      index 44be98f..898a812 100644
      --- a/add.rb
      +++ b/add.rb
      @@ -1,5 +1,5 @@
       module Add
      -  def add_4(x)
      -    x + 5
      +  def add_4(y)
      +    y + 5
         end
       end
      \ No newline at end of file
    """

  Scenario: Entering 's' for the same file to git blame into
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    When I type "3"
    Then I should see:
    """
        1) add.rb
    """
    When I type "s"
    Then I should see:
    """
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 2)   def add_4(x)
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 3)     x + 5
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end
    """

  Scenario: Entering the filename for the file to git blame into:
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    When I type "3"
    Then I should see:
    """
        1) add.rb
    """
    When I type "add.rb"
    Then I should see:
    """
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 2)   def add_4(x)
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 3)     x + 5
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end
    """

  Scenario: Re-viewing a git blame:
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    Then I should see:
    """
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
      5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 2)   def add_4(y)
      5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 3)     y + 5
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end
    """
    When I type "v"
    Then I should see:
    """
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
      5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 2)   def add_4(y)
      5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 3)     y + 5
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end
    """

  Scenario: Re-viewing a git show:
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    And I type "3"
    Then I should see:
    """
      commit 5087eab56af9b0901a1b190de14f29867307c140
      Author: Danny Dover <developers+danny@foo.com>
      Date:   Sat Jan 14 14:50:06 2012 -0800

          I like y's better

      diff --git a/add.rb b/add.rb
      index 44be98f..898a812 100644
      --- a/add.rb
      +++ b/add.rb
      @@ -1,5 +1,5 @@
       module Add
      -  def add_4(x)
      -    x + 5
      +  def add_4(y)
      +    y + 5
         end
       end
      \ No newline at end of file

        1) add.rb
    """
    When I type "v"
    Then I should see:
    """
      commit 5087eab56af9b0901a1b190de14f29867307c140
      Author: Danny Dover <developers+danny@foo.com>
      Date:   Sat Jan 14 14:50:06 2012 -0800

          I like y's better

      diff --git a/add.rb b/add.rb
      index 44be98f..898a812 100644
      --- a/add.rb
      +++ b/add.rb
      @@ -1,5 +1,5 @@
       module Add
      -  def add_4(x)
      -    x + 5
      +  def add_4(y)
      +    y + 5
         end
       end
      \ No newline at end of file

        1) add.rb
    """

  Scenario: Getting help interactively for git blame:
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    Then I should see:
    """
      (h for help) >
    """
    When I type "h"
    Then I should see:
    """
      Enter:
        - the line number from the above list (from 1 to 5) you are git blaming.
        - the sha to git blame chain into.
        - 'v' to view the git blame again

      (h for help) >
    """


  Scenario: Getting help interactively for git show:
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    And I type "3"
    Then I should see:
    """
      (h for help) >
    """
    When I type "h"
    Then I should see:
    """
      Enter:
        - 'q' to quit, if you have found the offending commit
        - the number from the above list (from 1 to 1) of the file to git blame chain into.
        - the filepath to git blame chain into.
        - 's' to git blame chain into the 'same' file as before
        - 'v' to view the git show again

      (h for help) >
    """


