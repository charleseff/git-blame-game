class GitBlameGame
  def initialize(path_to_file, opts={})
    @path_to_file = path_to_file
    @sha = !opts[:sha].nil? ? opts[:sha] : 'HEAD'
  end

  def run
    while true
      p_flush("\n")

      cmd = "git blame #{@sha} -- #{@path_to_file}"
      system cmd
      exit $?.exitstatus unless $?.success?
      git_blame_out = `#{cmd}`

      sha_list = get_sha_list(git_blame_out)
      sha_to_show = prompt_for_sha(sha_list)

      p_flush("\n")
      system "git show #{sha_to_show}"
      files_changed = `git show --pretty="format:" --name-only #{sha_to_show}`.split("\n")[1..-1]

      @path_to_file = prompt_for_file(files_changed, sha_to_show, @path_to_file)
      @sha = "#{sha_to_show}^"
    end
  end

  GIT_BLAME_REGEX = /(.+?) /

  def get_sha_list(git_blame_out)
    git_blame_out.strip.split("\n").map { |line| line[GIT_BLAME_REGEX, 1] }
  end

  def p_flush(str)
    $stdout.print str
    $stdout.flush
  end

  def prompt_for_continue(sha)
    p_flush "\n" + color("Do you need to git blame chain further? (y/n) >") + ' '
    input = $stdin.gets.strip.downcase
    until %w{y n}.include?(input)
      p_flush "\n" + color("Invalid input.  Enter y or n >") + ' '
      input = $stdin.gets.strip.downcase
    end

    if input == 'n'
      p_flush "\n" + color("The responsible commit is:") + "\n\n"
      system "git log #{sha} -n 1"
      exit 0
    end
  end

  def prompt_for_file(files_changed, sha, prior_file)
    print_file_prompt(files_changed)

    while true
      input = $stdin.gets.strip
      if input == 'q'
        p_flush "\n" + color("The responsible commit is:") + "\n\n"
        system "git log #{sha} -n 1"
        exit 0
      end
      return prior_file if input == 's'
      return input if files_changed.include? input
      input = input.to_i
      return files_changed[input-1] if input >= 1 && input <= files_changed.size

      p_flush "\n" + color("Invalid input.  ") + prompt_for_file_message(files_changed.size)
    end
  end

  def print_file_prompt(files)
    print("\n")
    files.each_with_index do |file, index|
      print color(sprintf("%3d) #{file}", index+1)) + "\n"
    end
    p_flush "\n" + prompt_for_file_message(files.size)
  end

  def prompt_for_file_message(size)
    color("Enter any of:") + "\n" +
      "  " + color("- 'q' to quit, if you have found the offending commit") + "\n" +
      "  " + color("- the number from the above list (from 1 to #{size}) of the file to git blame chain into.") + "\n" +
      "  " + color("- the filepath to git blame chain into.") + "\n" +
      "  " + color("- 's' to git blame chain into the 'same' file as before") + "\n\n" +
      color(">") + " "
  end

  def prompt_for_sha(shas)
    p_flush "\n" + color("Which line are you concerned with?") + "\n" +
              color("Enter a number from 1 to #{shas.count} or paste the SHA you want to show >") + ' '
    while true
      input = $stdin.gets.strip
      # sha was entered, return it:
      return input if shas.include? input

      if input =~ /\A\d+\Z/
        input = input.to_i
        return shas[input - 1] if input <= shas.count && input >= 1
      end

      p_flush "\n" + color("Invalid input.  Enter a number from 1 to #{shas.count} or paste the SHA you want to show >") + ' '
    end
  end

  def color(s)
    s.colorize(:color => :light_white, :background => :magenta)
  end
end