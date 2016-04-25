require 'open3'

class GitBlameGame
  def initialize(p, opts={})
    @path_to_file = set_path_to_file(p)
    @sha = !opts[:sha].nil? ? opts[:sha] : 'HEAD'
  end

  def run
    loop do
      p_flush("\n")

      sha_to_show = show_git_blame_and_prompt_for_sha

      p_flush("\n")
      files_changed = git_run(%Q{show --pretty="format:" --name-only #{sha_to_show}})[0].split("\n")

      @path_to_file = prompt_for_file(files_changed, sha_to_show)
      @sha = "#{sha_to_show}^"
    end
  end

  private
  def git_run(cmd)
    git_cmd = "git #{cmd}"
    ret = Open3.capture3(git_cmd, :chdir => git_root_path)
    exitstatus = ret[2].exitstatus
    if exitstatus != 0
      $stderr.print("Error: got exit status #{exitstatus} running `#{git_cmd}`\n")
      exit 1
    end
    ret
  end

  def show_git_blame_and_prompt_for_sha
    git_blame_out = git_run(git_blame_cmd)[0]
    exit $?.exitstatus unless $?.success?
    sha_list = get_sha_list(git_blame_out)
    print_git_blame_and_prompt
    prompt_for_sha(sha_list)
  end

  def prompt_for_sha(shas)
    loop do
      input = $stdin.gets.strip
      # sha was entered, return it:
      return input if shas.include? input

      if input =~ /\A\d+\Z/
        input = input.to_i
        return shas[input - 1] if input <= shas.count && input >= 1
      end

      if input == 'r'
        print_git_blame_and_prompt
      elsif input == 'h'
        p_flush prompt_for_sha_message(shas.count)
      else
        p_flush "\nInvalid input.  " + prompt_for_sha_message(shas.count)
      end
    end
  end

  def print_git_blame_and_prompt
    p_flush git_run(git_blame_cmd)[0]
    p_flush "\n" + simple_prompt
  end

  def git_blame_cmd
    "blame #{@sha} -- #{@path_to_file}"
  end

  GIT_BLAME_REGEX = /(.+?) /

  def get_sha_list(git_blame_out)
    git_blame_out.strip.split("\n").map { |line| line[GIT_BLAME_REGEX, 1] }
  end

  def prompt_for_file(files_changed, sha)
    print_file_prompt(files_changed, sha)

    loop do
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

      if input == 'r'
        print_file_prompt(files_changed, sha)
      elsif input == 'h'
        p_flush prompt_for_file_message(files_changed.count)
      else
        p_flush "\nInvalid input.  " + prompt_for_file_message(files_changed.count)
      end
    end
  end

  def print_file_prompt(files, sha)
    p_flush(git_run("show #{sha}")[0])
    print("\n")
    files.each_with_index do |file, index|
      line = sprintf("%3d) #{file}", index+1)
      line += '   ' + orange_color("(or 's' for same)") if file == @path_to_file
      print line + "\n"
    end
    p_flush "\n" + simple_prompt
  end

  def prompt_for_file_message(count)
    "Enter:\n" +
      "  - 'q' to quit, if you have found the offending commit\n" +
      "  - the number from the above list (from 1 to #{count}) of the file to git blame chain into.\n" +
      "  - the filepath to git blame chain into.\n" +
      "  - 's' to git blame chain into the 'same' file as before\n" +
      "  - 'r' to re-view the git show\n\n" +
      simple_prompt
  end

  def simple_prompt
    color("(h for help) >") + ' '
  end

  def prompt_for_sha_message(count)
    "Enter:\n" +
      "  - the line number from the above list (from 1 to #{count}) you are git blaming.\n" +
      "  - the sha to git blame chain into.\n" +
      "  - 'r' to re-view the git blame\n\n" + simple_prompt
  end

  def p_flush(str)
    $stdout.print str
    $stdout.flush
  end

  def color(s)
    s.colorize(:color => :light_white, :background => :magenta)
  end

  def orange_color(s)
    s.colorize(:color => :yellow, :background => :black)
  end

  def git_root_path
    @git_root_path ||= "#{`git rev-parse --show-toplevel`.strip}/"
  end

  # sets the path to be relative to the git root
  def set_path_to_file(path_to_file)
    @path_to_file =
      if path_to_file.start_with?('/')
        path_to_file.gsub(git_root_path, '')
      else
        # puts "ENV['PWD']=#{ENV['PWD']}, "
        "#{ENV['PWD'].gsub(git_root_path, '')}/#{path_to_file}"
      end
  end

end