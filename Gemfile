source 'https://rubygems.org'

# Allow testing multiple versions with Travis.
rails_version = ENV['RAILS_VERSION']
if rails_version && rails_version.length > 0
  puts "Testing Rails Version = #{rails_version}"
  # Override the specific versions
  gem 'activesupport', rails_version
  gem 'activerecord',  rails_version
end

gemspec
