module Pseudocephalopod
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