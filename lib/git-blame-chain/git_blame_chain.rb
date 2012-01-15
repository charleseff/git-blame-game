class GitBlameChain
  def initialize(path_to_file, opts={})
    @path_to_file = path_to_file
    @sha = opts[:sha].present? ? opts[:sha] : 'HEAD'
  end

  def run
    loop
  end

  GIT_BLAME_REGEX = /(.+?) /

  def loop
    out = `git blame #{@sha} -- #{@path_to_file}`
    puts out
    exit $?.exitstatus unless $?.success?

    lines = out.split("\n")
    count = lines.count

    input = prompt_for_line(count)
    sha_to_show = lines[input]

    out = `git show #{sha_to_show}`

    # git log de2a1d78f80e02a515cdd3aa0420dd6ee35b510b -n 1

  end

  def prompt_for_line(count)
    print "\nWhich line are you concerned with? (1 to #{count}) > "
    input = $stdin.gets
    input = input.strip.to_i
    until input >= 1 && input <= count
      print "Invalid input.  Please enter a number from 1 to #{count} > "
      input = $stdin.gets
      input = input.strip.to_i
    end
    input
  end
end