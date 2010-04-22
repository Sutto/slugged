module Pseudocephalopod
  class MemoryCache
    
    @@cache = {}
    
    def self.write(key, value)
      @@cache[key.to_s] = value
    end
    
    def self.read(key)
      @@cache[key.to_s]
    end
    
    def self.reset!
      @@cache = {}
    end
    
  end
end