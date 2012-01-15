require 'aruba/cucumber'

Before do
  fixtures_dir = File.expand_path(File.dirname(__FILE__)) + '/../fixtures'
  unless File.directory? fixtures_dir + '/sample_git_repo'
    `unzip #{fixtures_dir}/sample_git_repo.zip  -d #{fixtures_dir}`
  end
end