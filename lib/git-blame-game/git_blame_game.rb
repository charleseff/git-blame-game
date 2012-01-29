class GitBlameGame
  def initialize(path_to_file, opts={})
    @path_to_file = path_to_file
    @sha = !opts[:sha].nil? ? opts[:sha] : 'HEAD'
  end

  def run
    while true
      p_flush("\n")

      sha_to_show = show_git_blame_and_prompt_for_sha

      p_flush("\n")
      files_changed = `git show --pretty="format:" --name-only #{sha_to_show}`.split("\n")[1..-1]

      @path_to_file = prompt_for_file(files_changed, sha_to_show)
      @sha = "#{sha_to_show}^"
    end
  end

  private
  def show_git_blame_and_prompt_for_sha
    git_blame_out = `#{git_blame_cmd}`
    exit $?.exitstatus unless $?.success?
    sha_list = get_sha_list(git_blame_out)
    print_git_blame_and_prompt
    prompt_for_sha(sha_list)
  end

  def prompt_for_sha(shas)
    while true
      input = $stdin.gets.strip
      # sha was entered, return it:
      return input if shas.include? input

      if input =~ /\A\d+\Z/
        input = input.to_i
        return shas[input - 1] if input <= shas.count && input >= 1
      end

      if input == 'v'
        print_git_blame_and_prompt
      elsif input == 'h'
        p_flush prompt_for_sha_message(shas.count)
      else
        p_flush "\nInvalid input.  " + prompt_for_sha_message(shas.count)
      end
    end
  end

  def print_git_blame_and_prompt
    system git_blame_cmd
    p_flush "\n" + simple_prompt
  end

  def git_blame_cmd
    "git blame #{@sha} -- #{@path_to_file}"
  end

  GIT_BLAME_REGEX = /(.+?) /

  def get_sha_list(git_blame_out)
    git_blame_out.strip.split("\n").map { |line| line[GIT_BLAME_REGEX, 1] }
  end

  def prompt_for_file(files_changed, sha)
    print_file_prompt(files_changed, sha)

    while true
      input = $stdin.gets.strip
      if input == 'q'
        p_flush "\n" + color("The responsible commit is:") + "\n\n"
        system "git log #{sha} -n 1"
        exit 0
      end
      return @path_to_file if input == 's'
      return input if files_changed.include? input

      if input =~ /\A\d+\Z/
        input = input.to_i
        return files_changed[input-1] if input >= 1 && input <= files_changed.count
      end

      if input == 'v'
        print_file_prompt(files_changed, sha)
      elsif input == 'h'
        p_flush prompt_for_file_message(files_changed.count)
      else
        p_flush "\nInvalid input.  " + prompt_for_file_message(files_changed.count)
      end
    end
  end

  def print_file_prompt(files, sha)
    system "git show #{sha}"
    print("\n")
    files.each_with_index do |file, index|
      print sprintf("%3d) #{file}", index+1) + "\n"
    end
    p_flush "\n" + simple_prompt
  end

  def prompt_for_file_message(count)
    "Enter:\n" +
      "  - 'q' to quit, if you have found the offending commit\n" +
      "  - the number from the above list (from 1 to #{count}) of the file to git blame chain into.\n" +
      "  - the filepath to git blame chain into.\n" +
      "  - 's' to git blame chain into the 'same' file as before\n" +
      "  - 'v' to view the git show again\n\n" +
      simple_prompt
  end

  def simple_prompt
    color("(h for help) >") + ' '
  end

  def prompt_for_sha_message(count)
    "Enter:\n" +
      "  - the line number from the above list (from 1 to #{count}) you are git blaming.\n" +
      "  - the sha to git blame chain into.\n" +
      "  - 'v' to view the git blame again\n\n" + simple_prompt
  end

  def p_flush(str)
    $stdout.print str
    $stdout.flush
  end

  def color(s)
    s.colorize(:color => :light_white, :background => :magenta)
  end
end