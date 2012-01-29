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

  Scenario: With a SHA:
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game blah.rb --sha=63b41ee41653991aa00ce9687e3f403efd4c29d4` interactively
    Then the next bit of output should contain, ignoring spaces:
    """
      ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 1) def add_4(x)
      63b41ee4 (Bob Barker 2012-01-14 14:46:53 -0800 2)   x + 5
      ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 3) end
      ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 4)
      ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 5) puts add_4(9) # should be 13

      Which line are you concerned with?
      Enter a number from 1 to 5 or paste the SHA you want to show >
    """

  Scenario: Entering the SHA instead of the number
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    When I type "5087eab5"
    Then the next bit of output should contain, ignoring spaces:
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
    Then the next bit of output should contain, ignoring spaces:
    """
        1) add.rb

      Enter any of:
        - 'q' to quit, if you have found the offending commit
        - the number from the above list (from 1 to 1) of the file to git blame chain into.
        - the filepath to git blame chain into.
        - 's' to git blame chain into the 'same' file as before
    """
    When I type "s"
    Then the next bit of output should contain, ignoring spaces:
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
    Then the next bit of output should contain, ignoring spaces:
    """
        1) add.rb

      Enter any of:
        - 'q' to quit, if you have found the offending commit
        - the number from the above list (from 1 to 1) of the file to git blame chain into.
        - the filepath to git blame chain into.
        - 's' to git blame chain into the 'same' file as before
    """
    When I type "add.rb"
    Then the next bit of output should contain, ignoring spaces:
    """
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 2)   def add_4(x)
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 3)     x + 5
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end
    """
