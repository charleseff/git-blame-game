Feature: The happy path

  Scenario: Without a SHA:
    Given I cd to "test/fixtures/sample_git_repo"
    When I run `../../../bin/git-blame-game add.rb` interactively
    Then the next bit of output should contain, ignoring spaces:
    """
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
      5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 2)   def add_4(y)
      5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 3)     y + 5
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
      de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end

      Which line are you concerned with?
      Enter a number from 1 to 5 or paste the SHA you want to show >
    """
    When I type "foobar"
    Then the next bit of output should contain, ignoring spaces:
    """
      Invalid input.  Enter a number from 1 to 5 or paste the SHA you want to show >
    """
    When I type "3"
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

        1) add.rb

      Enter any of:
        - 'q' to quit, if you have found the offending commit
        - the number from the above list (from 1 to 1) of the file to git blame chain into.
        - the filepath to git blame chain into.
        - 's' to git blame chain into the 'same' file as before

      >
    """
    When I type "blah"
    Then the next bit of output should contain, ignoring spaces:
    """
      Invalid input.  Enter any of:
        - 'q' to quit, if you have found the offending commit
        - the number from the above list (from 1 to 1) of the file to git blame chain into.
        - the filepath to git blame chain into.
        - 's' to git blame chain into the 'same' file as before

      >
    """
    When I type "1"
    Then the next bit of output should contain, ignoring spaces:
    """
          de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
          de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 2)   def add_4(x)
          de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 3)     x + 5
          de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
          de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end

          Which line are you concerned with?
          Enter a number from 1 to 5 or paste the SHA you want to show >
    """
    When I type "3"
    Then the next bit of output should contain, ignoring spaces:
    """
      commit de2a1d78f80e02a515cdd3aa0420dd6ee35b510b
      Author: Carmen Cummings <developers+carmen@foo.com>
      Date:   Sat Jan 14 14:49:00 2012 -0800

          moving add_4 to module

      diff --git a/add.rb b/add.rb
      new file mode 100644
      index 0000000..44be98f
      --- /dev/null
      +++ b/add.rb
      @@ -0,0 +1,5 @@
      +module Add
      +  def add_4(x)
      +    x + 5
      +  end
      +end
      \ No newline at end of file
      diff --git a/blah.rb b/blah.rb
      index 0424947..38b7511 100644
      --- a/blah.rb
      +++ b/blah.rb
      @@ -1,5 +1,5 @@
      -def add_4(x)
      -  x + 5
      -end
      +$:.unshift(File.dirname(__FILE__))
      +require 'add'
      +include Add

       puts add_4(9) # should be 13
      \ No newline at end of file

        1) add.rb
        2) blah.rb

      Enter any of:
        - 'q' to quit, if you have found the offending commit
        - the number from the above list (from 1 to 2) of the file to git blame chain into.
        - the filepath to git blame chain into.
        - 's' to git blame chain into the 'same' file as before

      >
    """
    When I type "2"
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
    When I type "2"
    Then the next bit of output should contain, ignoring spaces:
    """
      commit 63b41ee41653991aa00ce9687e3f403efd4c29d4
      Author: Bob Barker <developers+bob@foo.com>
      Date:   Sat Jan 14 14:46:53 2012 -0800

          being bad

      diff --git a/blah.rb b/blah.rb
      index 626a42b..0424947 100644
      --- a/blah.rb
      +++ b/blah.rb
      @@ -1,5 +1,5 @@
       def add_4(x)
      -  x + 4
      +  x + 5
       end

       puts add_4(9) # should be 13
      \ No newline at end of file

        1) blah.rb

      Enter any of:
        - 'q' to quit, if you have found the offending commit
        - the number from the above list (from 1 to 1) of the file to git blame chain into.
        - the filepath to git blame chain into.
        - 's' to git blame chain into the 'same' file as before

      >
    """
    When I type "q"
    Then the next bit of output should contain, ignoring spaces:
    """
    The responsible commit is:

    commit 63b41ee41653991aa00ce9687e3f403efd4c29d4
    Author: Bob Barker <developers+bob@foo.com>
    Date:   Sat Jan 14 14:46:53 2012 -0800

        being bad
    """

