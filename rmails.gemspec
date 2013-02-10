Gem::Specification.new do |s|
  s.name               = "rmails"
  s.version            = "0.0.1"
  s.default_executable = "rmails"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pavel Novotny"]
  s.date = %q{2013-01-12}
  s.description = %q{Setup for e-mail server and admin application}
  s.email = %q{fandisek@gmail.com}
  s.files = `ls -r`.split("\n")
  s.test_files = [""]
  s.homepage = %q{http://rubygems.org/gems/rmails}
  s.require_paths = %w( app config db lib public script system )
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

