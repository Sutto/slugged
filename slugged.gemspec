# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require 'slugged/version'

Gem::Specification.new do |s|
  s.name = %q{slugged}
  s.version = Slugged::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Darcy Laycock"]
  s.date = %q{2011-01-01}
  s.description = %q{Super simple slugs for ActiveRecord 3.0 and higher, with support for slug history}
  s.email = %q{sutto@sutto.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.homepage = %q{http://github.com/Sutto/slugged}
  s.rdoc_options = ["--charset=UTF-8"]
  s.summary = %q{Super simple slugs for ActiveRecord 3.0 and higher, with support for slug history}

  s.add_runtime_dependency(%q<activerecord>, ["~> 3"])
  s.add_runtime_dependency(%q<activesupport>, ["~> 3"])
  s.add_runtime_dependency(%q<uuid>, [">= 0"])
  s.add_development_dependency(%q<shoulda>, [">= 0"])
  s.add_development_dependency(%q<reversible_data>, [">= 0"])
  s.add_development_dependency(%q<sqlite3-ruby>)
  s.add_development_dependency(%q<redgreen>) if RUBY_VERSION < "1.9"
  s.add_development_dependency(%q<rcov>)
  s.add_development_dependency(%q<reek>)  
  s.add_development_dependency(%q<roodi>)  
  s.add_development_dependency(%q<flay>)
  s.add_development_dependency(%q<flog>)  
  s.add_development_dependency(%q<Saikuro>)  
  s.add_development_dependency(%q<ruby-debug>)
  s.add_development_dependency(%q<rdoc>)
  s.add_development_dependency(%q<rake>, '> 0.9')  
end

