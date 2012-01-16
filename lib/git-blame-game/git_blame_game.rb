class GitBlameGame
  def initialize(path_to_file, opts={})
    @path_to_file = path_to_file
    @sha = !opts[:sha].nil? ? opts[:sha] : 'HEAD'
  end

  def run
    while loop;
    end
  end

  GIT_BLAME_REGEX = /(.+?) /

  def loop
    puts
    out = run_idempotent_git_command("git blame #{@sha} -- #{@path_to_file}")
    exit $?.exitstatus unless $?.success?

    lines = out.split("\n")
    count = lines.count

    line = prompt_for_line(count)
    sha_to_show = lines[line-1][GIT_BLAME_REGEX, 1]

    puts
    system "git show #{sha_to_show}"
    files_changed = `git show --pretty="format:" --name-only #{sha_to_show}`.split("\n")[1..-1]

    prompt_for_continue(sha_to_show)

    @path_to_file = prompt_for_file(files_changed)
    @sha = "#{sha_to_show}^"

    true
  end

  def prompt_for_continue(sha)
    print "\n" + gbc_color("Do you need to git blame chain further? (y/n) >") + ' '
    input = $stdin.gets.strip.downcase
    until %w{y n}.include?(input)
      print "\n" + gbc_color("Invalid input.  Enter y or n >") + ' '
      input = $stdin.gets.strip.downcase
    end

    if input == 'n'
      print "\n" + gbc_color("The responsible commit is:") + "\n\n"
      system "git log #{sha} -n 1"
      exit 0
    end
  end

  def prompt_for_file(files_changed)
    puts
    files_changed.each_with_index do |file, index|
      printf("%3d) #{file}\n", index+1)
    end

    print "\n" + gbc_color("Enter the number (from 1 to #{files_changed.size}) of the file to git blame chain into >") + ' '
    until (input = $stdin.gets.strip.to_i) >= 1 && input <= files_changed.size
      print "\n" + gbc_color("Invalid input.  Enter a number from 1 to #{files_changed.size} >") + ' '
    end

    return files_changed[input-1]

  end

  def prompt_for_line(count)
    print "\n" + gbc_color("Which line are you concerned with? (1 to #{count}) >") + ' '
    until (input = $stdin.gets.strip.to_i) >= 1 && input <= count
      print "\n" + gbc_color("Invalid input.  Enter a number from 1 to #{count} >") + ' '
    end
    input
  end

  def run_idempotent_git_command(cmd)
    system cmd
    `#{cmd}`
  end

  def gbc_color(s)
    s.colorize(:color => :light_white, :background => :magenta)
  end
end