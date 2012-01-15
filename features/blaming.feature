Feature: Blaming

  Scenario: Getting help
    When I run `bin/git-blame-chain --help`
    Then it should pass with:
    """
    Usage: git-blame-chain [options] path/to/filename
    """

  Scenario: Without a filepath:
    When I run `bin/git-blame-chain`
    Then it should fail with:
    """
    missing argument: You must specify a path to a file
    """

  Scenario: Specifying a file that doesn't exist:
    When I run `bin/git-blame-chain file/that/doesnt/exist.rb`
    Then it should fail with:
    """
    fatal: no such path file/that/doesnt/exist.rb in HEAD
    """

  Scenario: Without a SHA:
    Given I cd to "features/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-chain add.rb`
    Then the output should contain:
    """
    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
    5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 2)   def add_4(y)
    5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 3)     y + 5
    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end

    Which line are you concerned with? (1 to 5) >
    """
    When I type "foobar"
    Then the output should contain:
    """
    Invalid input.  Please enter a number from 1 to 5 >
    """
    When I type "1"
