class GitBlameChain
  def initialize(path_to_file, opts={})
    @path_to_file = path_to_file
    @sha = opts[:sha].present? ? opts[:sha] : 'HEAD'
  end

  def run
    system "git blame #{@sha} -- #{@path_to_file}"
    exit $?.exitstatus unless $?.success?
=begin
    while res = gets.chomp
      break if res == "quit"
      puts res.reverse
    end
=end
  end
end