require 'aruba/cucumber'

def unzip_git_repo_if_needed!
  fixtures_dir = File.expand_path(File.dirname(__FILE__)) + '/../fixtures'
  unless File.directory? fixtures_dir + '/sample_git_repo'
    `unzip #{fixtures_dir}/sample_git_repo.zip  -d #{fixtures_dir}`
  end
end

# for some reason Aruba sets the default dir to 'tmp/aruba'.  Override this:
def set_relative_dir_for_aruba!
  root_dir = File.expand_path("../../../", __FILE__)
  self.instance_variable_set('@dirs',  [root_dir])
end

Before do
  unzip_git_repo_if_needed!

  set_relative_dir_for_aruba!
end