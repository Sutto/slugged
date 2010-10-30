require 'helper'

class CachingTest < Test::Unit::TestCase
  with_tables :slugs, :users do
    
    setup { Slugged::MemoryCache.reset! }
    
    context 'with the default slug setup' do
      
      setup { setup_slugs! }
    
      should 'store a cache automatically after finding it' do
        assert_has_no_cache_for  "bob"
        u = User.create :name => "Bob"
        assert_has_cache_for     "bob"
        Slugged::MemoryCache.reset!
        assert_has_no_cache_for  "bob"
        assert_same_as_slug u,   "bob"
        assert_has_cache_for     "bob"
        assert_same_as_slug u,   "bob"
      end
    
      should 'automatically keep cache entries for history by default' do
        setup_slugs!
        assert_has_no_cache_for "bob"
        assert_has_no_cache_for "red"
        assert_has_no_cache_for "sam"
        user = User.create :name => "bob"
        assert_has_cache_for "bob"
        assert_has_no_cache_for "red"
        assert_has_no_cache_for "sam"
        user.update_attributes :name => "Red"
        assert_has_cache_for "bob"
        assert_has_cache_for "red"
        assert_has_no_cache_for "sam"
        user.update_attributes :name => "Sam"
        assert_has_cache_for "bob"
        assert_has_cache_for "red"
        assert_has_cache_for "sam"
      end
      
    end
    
    should 'remove cache on models without history' do
      setup_slugs! :history => false
      u = User.create :name => "Bob"
      assert_has_cache_for    "bob"
      assert_has_no_cache_for "red"
      assert_has_no_cache_for "sam"
      u.update_attributes :name => "Red"
      u.update_attributes :name => "Sam"
      assert_has_no_cache_for "bob"
      assert_has_no_cache_for "red"
      assert_has_cache_for    "sam"
    end
   
    should 'allow you to disable caching' do
      setup_slugs! :use_cache => false
      assert !User.respond_to?(:has_cache_for_slug?)
    end
    
    # Ensure we destroy the contents of the cache after each test.
    teardown { Slugged::MemoryCache.reset! }
    
  end
  
  protected
  
  def assert_has_cache_for(key)
    assert User.has_cache_for_slug?(key), "User should have a cache entry for #{key.inspect}"
  end
  
  def assert_has_no_cache_for(key)
    assert !User.has_cache_for_slug?(key), "User should not have a cache entry for #{key.inspect}"
  end
  
end