# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "git-blame-chain/version"

Gem::Specification.new do |s|
  s.name        = "git-blame-chain"
  s.version     = Git::Blame::Chain::VERSION
  s.authors     = ["Charles Finkel"]
  s.email       = ["charles.finkel@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "git-blame-chain"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'aruba'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'i18n'
end
