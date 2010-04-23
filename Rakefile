require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require

require 'rake'

require File.expand_path('../lib/pseudocephalopod/version', __FILE__)

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version     = Pseudocephalopod::Version::STRING
    gem.name        = "pseudocephalopod"
    gem.summary     = %Q{Super simple slugs for ActiveRecord 3.0 and higher, with support for slug history}
    gem.description = %Q{Super simple slugs for ActiveRecord 3.0 and higher, with support for slug history}
    gem.email       = "sutto@sutto.net"
    gem.homepage    = "http://github.com/Sutto/pseudocephalopod"
    gem.authors     = ["Darcy Laycock"]
    gem.add_dependency "activerecord", ">= 3.0.0.beta2"
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_development_dependency "reversible_data"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
    test.rcov_opts << '--exclude \.bundle-cache --exclude gems-switcher'
    test.output_dir = "metrics/coverage"
  end
rescue LoadError
  task :rcov do
    abort "Rcov isn't installed, please run via bundle exec after bundle installing"
  end
end

task :metrics => [:rcov, :saikuro, :reek, :flay, :flog, :roodi]

task :test => :check_dependencies

task :flog do
  system "flog lib"
end

task :saikuro do
  system "rm -rf metrics/saikuro && mkdir -p metrics/saikuro && saikuro -c -t -i lib/ -y 0 -w 11 -e 16 -o metrics/saikuro/"
end

begin
  require 'flay'
  require 'flay_task'
  FlayTask.new
rescue LoadError
  task :flay do
    abort "Flay isn't installed, please run via bundle exec after bundle installing"
  end
end

begin
  require 'reek/rake/task'
  Reek::Rake::Task.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek isn't installed, please run via bundle exec after bundle installing"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi isn't installed, please run via bundle exec after bundle installing"
  end
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "pseudocephalopod #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
