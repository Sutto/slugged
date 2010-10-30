$KCODE = 'UTF8'

require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require

require 'test/unit'
require 'shoulda'
require 'redgreen' if RUBY_VERSION < '1.9'
require 'ruby-debug' if ENV['DEBUG']

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'slugged'
require 'model_definitions'

# Use a memory cache for testing.
Slugged.cache = Slugged::MemoryCache

class Test::Unit::TestCase
  extend ReversibleData::ShouldaMacros
  
  def setup_slugs!(*args)
    options = args.extract_options!
    field   = args.pop || :name
    User.is_sluggable field, options
  end
  
  def assert_same_as_slug(user, slug, options = {})
    found_user = User.find_using_slug(slug, options)
    assert_equal user, found_user, "#{slug.inspect} should return #{user.inspect}, got #{found_user.inspect}"
  end
  
  def assert_different_to_slug(user, slug, options = {})
    found_user = User.find_using_slug(slug, options)
    assert_not_equal user, found_user, "#{slug.inspect} should not return #{user.inspect}, got same record."
  end
  
  def assert_none_for_slug(slug)
    assert User.find_using_slug(slug).blank?, "slug #{slug.inspect} should not return any records."
  end
  
end
