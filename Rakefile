require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

task :default => :test

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
    test.rcov_opts << '--exclude /gems/,/Library/,/usr/,lib/tasks,.bundle,config,/lib/rspec/,/lib/rspec-'
    test.output_dir = "metrics/coverage"
  end
rescue LoadError
  task :rcov do
    abort "Rcov isn't installed, please run via bundle exec after bundle installing"
  end
end

task :metrics => [:rcov, :saikuro, :reek, :flay, :flog, :roodi]

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

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "slugged #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
