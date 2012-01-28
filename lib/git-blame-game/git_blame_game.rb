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
    p_flush("\n")

    cmd = "git blame #{@sha} -- #{@path_to_file}"
    system cmd
    exit $?.exitstatus unless $?.success?
    out = `#{cmd}`

    lines = out.split("\n")
    count = lines.count

    line = prompt_for_line(count)
    sha_to_show = lines[line-1][GIT_BLAME_REGEX, 1]

    p_flush("\n")
    system "git show #{sha_to_show}"
    files_changed = `git show --pretty="format:" --name-only #{sha_to_show}`.split("\n")[1..-1]

    prompt_for_continue(sha_to_show)

    @path_to_file = prompt_for_file(files_changed)
    @sha = "#{sha_to_show}^"

    true
  end

  def p_flush(str)
    $stdout.print str
    $stdout.flush
  end

  def prompt_for_continue(sha)
    p_flush "\n" + gbc_color("Do you need to git blame chain further? (y/n) >") + ' '
    input = $stdin.gets.strip.downcase
    until %w{y n}.include?(input)
      p_flush "\n" + gbc_color("Invalid input.  Enter y or n >") + ' '
      input = $stdin.gets.strip.downcase
    end

    if input == 'n'
      p_flush "\n" + gbc_color("The responsible commit is:") + "\n\n"
      system "git log #{sha} -n 1"
      exit 0
    end
  end

  def prompt_for_file(files_changed)
    p_flush("\n")
    files_changed.each_with_index do |file, index|
      $stdout.printf("%3d) #{file}\n", index+1)
      $stdout.flush
    end

    p_flush "\n" + gbc_color("Enter the number (from 1 to #{files_changed.size}) of the file to git blame chain into >") + ' '
    until (input = $stdin.gets.strip.to_i) >= 1 && input <= files_changed.size
      p_flush "\n" + gbc_color("Invalid input.  Enter a number from 1 to #{files_changed.size} >") + ' '
    end

    return files_changed[input-1]

  end

  def prompt_for_line(count)
    p_flush "\n" + gbc_color("Which line are you concerned with? (1 to #{count}) >") + ' '
    until (input = $stdin.gets.strip.to_i) >= 1 && input <= count
      p_flush "\n" + gbc_color("Invalid input.  Enter a number from 1 to #{count} >") + ' '
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