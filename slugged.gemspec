# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require 'slugged/version'

Gem::Specification.new do |s|
  s.name                      = "slugged"
  s.version                   = Slugged::VERSION
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors                   = ["Darcy Laycock"]
  s.date                      = %q{2011-01-01}
  s.description               = %q{Super simple slugs for ActiveRecord 3.0 and higher, with support for slug history}
  s.email                     = %q{sutto@sutto.net}
  s.extra_rdoc_files          = ["LICENSE", "README.md"]
  s.files                     = `git ls-files`.split("\n")
  s.test_files                = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths             = ["lib"]
  s.homepage                  = %q{http://github.com/Sutto/slugged}
  s.rdoc_options              = ["--charset=UTF-8"]
  s.summary                   = %q{Super simple slugs for ActiveRecord 3.0 and higher, with support for slug history}

  s.add_runtime_dependency "activerecord",  ">= 3.0"
  s.add_runtime_dependency "activesupport", ">= 3.0"
  s.add_runtime_dependency "uuid"

  s.add_development_dependency "shoulda"
  s.add_development_dependency "reversible_data"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "redgreen"
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc"
end

