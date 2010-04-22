$KCODE = 'UTF8'

require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require

require 'test/unit'
require 'shoulda'
require 'redgreen' if RUBY_VERSION < '1.9'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'pseudocephalopod'
require 'model_definitions'

# Use a memory cache for testing.
Pseudocephalopod.cache = Pseudocephalopod::MemoryCache

class Test::Unit::TestCase
  extend ReversibleData::ShouldaMacros
end
