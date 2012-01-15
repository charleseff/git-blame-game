git-blame-game
=======

<img src="https://github.com/charleseff/git-blame-game/raw/master/public/pensive_kanye.png" />

git-blame-game is an interactive command-line tool for chaining 'git blame' calls to drill-down to the real culprit for the line of code you care about.  When one `git blame` does not tell the whole story.

## Installation:

    gem install git-blame-game

## Usage:

    git-blame-game --help

## Example:

    $ git-blame-game add.rb

    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
    5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 2)   def add_4(y)
    5087eab5 (Danny Dover     2012-01-14 14:50:06 -0800 3)     y + 5
    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end

    Which line are you concerned with? (1 to 5) > 3

    commit 5087eab56af9b0901a1b190de14f29867307c140 (HEAD, master)
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

    Do you need to git blame chain further (y/n) > y

      1) add.rb

    Enter the number (from 1 to 1) of the file to git blame chain into > 1

    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 1) module Add
    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 2)   def add_4(x)
    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 3)     x + 5
    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 4)   end
    de2a1d78 (Carmen Cummings 2012-01-14 14:49:00 -0800 5) end

    Which line are you concerned with? (1 to 5) > 3

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

    Do you need to git blame chain further (y/n) > y

      1) add.rb
      2) blah.rb

    Enter the number (from 1 to 2) of the file to git blame chain into > 2

    ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 1) def add_4(x)
    63b41ee4 (Bob Barker 2012-01-14 14:46:53 -0800 2)   x + 5
    ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 3) end
    ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 4)
    ^f603a9a (Alice Amos 2012-01-14 14:46:18 -0800 5) puts add_4(9) # should be 13

    Which line are you concerned with? (1 to 5) > 2

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

    Do you need to git blame chain further (y/n) > n

    The responsible commit is:

    commit 63b41ee41653991aa00ce9687e3f403efd4c29d4
    Author: Bob Barker <developers+bob@foo.com>
    Date:   Sat Jan 14 14:46:53 2012 -0800

        being bad
