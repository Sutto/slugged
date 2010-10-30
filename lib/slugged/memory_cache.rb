module Slugged
  # Implements a simple cache store that uses the
  # current processes memory. This makes is primarily
  # used for testing purposes in the situations where
  # caching is used.
  class MemoryCache
    
    def self.write(key, value, options = {})
      cache[key.to_s] = value
    end
    
    def self.read(key)
      cache[key.to_s]
    end
    
    def self.delete(key)
      cache.delete key.to_s
    end
    
    def self.reset!
      @cache = nil
    end
    
    def self.cache
      @cache ||= {}
    end
    
  end
end