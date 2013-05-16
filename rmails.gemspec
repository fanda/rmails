require File.expand_path('../lib/rmails/version', __FILE__)

Gem::Specification.new do |s|
  s.name               = "rmails"
  s.version            = Rmails::VERSION
  s.default_executable = "rmails"
  s.license            = 'MIT'

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pavel Novotny"]
  s.date = %q{2013-01-12}
  s.description = %q{Setup for e-mail server and its admin application}
  s.email = %q{fandisek@gmail.com}
  s.homepage = %q{http://rubygems.org/gems/rmails}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Autoinstall e-mail server and configure it with Ruby on Rails}
  s.bindir = 'bin'

  s.add_dependency 'bundler'
  s.add_dependency 'hoe'
  s.add_dependency 'open4'
  s.add_dependency 'rails'
  s.add_dependency 'devise'
  s.add_dependency 'thin'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  #s.post_install do
  #  `sudo ln -s \`which rake\` /usr/local/bin/`
  #end
end

