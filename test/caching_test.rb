require 'helper'

class CachingTest < Test::Unit::TestCase
  with_tables :slugs, :users, :unslugged_users do
    
    setup { Pseudocephalopod::MemoryCache.reset! }
    
    should 'store a cache automatically after finding it' do
      assert !User.has_cache_for_slug?("bob")
      u = User.create :name => "Bob"
      assert User.has_cache_for_slug?("bob")
      Pseudocephalopod::MemoryCache.reset!
      assert !User.has_cache_for_slug?("bob")
      assert_equal u, User.find_using_slug("bob")
      assert User.has_cache_for_slug?("bob")
      # Second find from cache
      assert_equal u, User.find_using_slug("bob")
    end
    
    should 'remove cache on models without history' do
      UnsluggedUser.is_sluggable :name, :history => false
      u = UnsluggedUser.create :name => "Bob"
      assert UnsluggedUser.has_cache_for_slug?("bob")
      assert !UnsluggedUser.has_cache_for_slug?("red")
      assert !UnsluggedUser.has_cache_for_slug?("sam")
      u.update_attributes :name => "Red"
      u.update_attributes :name => "Sam"
      assert !UnsluggedUser.has_cache_for_slug?("bob")
      assert !UnsluggedUser.has_cache_for_slug?("red")
      assert UnsluggedUser.has_cache_for_slug?("sam")
    end
    
    should 'automatically keep cache entries for history by default' do
      assert !User.has_cache_for_slug?("bob")
      assert !User.has_cache_for_slug?("red")
      assert !User.has_cache_for_slug?("sam")
      user = User.create :name => "bob"
      assert User.has_cache_for_slug?("bob")
      assert !User.has_cache_for_slug?("red")
      assert !User.has_cache_for_slug?("sam")
      user.update_attributes :name => "Red"
      assert User.has_cache_for_slug?("bob")
      assert User.has_cache_for_slug?("red")
      assert !User.has_cache_for_slug?("sam")
      user.update_attributes :name => "Sam"
      assert User.has_cache_for_slug?("bob")
      assert User.has_cache_for_slug?("red")
      assert User.has_cache_for_slug?("sam")
    end
   
    should 'allow you to disable caching' do
      UnsluggedUser.is_sluggable :name, :use_cache => false
      assert !UnsluggedUser.respond_to?(:has_cache_for_slug?)
    end
    
    # Ensure we destroy the contents of the cache after each test.
    teardown { Pseudocephalopod::MemoryCache.reset! }
    
  end
end