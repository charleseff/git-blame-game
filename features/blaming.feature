Feature: Blaming

  Scenario: Getting help
    When I run `bin/git-blame-chain --help`
    Then the output should contain:
    """
    Usage: git-blame-chain [options] path/to/filename
    """

  Scenario: Without a SHA:
    Given I cd to "features/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-chain blah.rb blah.rb`
    Then the output should contain:
    """

    """