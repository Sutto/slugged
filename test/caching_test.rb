require 'helper'

class CachingTest < Test::Unit::TestCase
  context 'when caching' do
    
    should 'store a cache automatically after finding it'
    
    # Ensure we destroy the contents of the cache after each test.
    teardown { Pseudocephalopod::MemoryCache.reset! }
    
  end
end