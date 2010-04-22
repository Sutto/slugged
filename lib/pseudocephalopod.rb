require 'uuid'

module Pseudocephalopod
  class << self
    
    def with_counter(prefix, counter = 0)
      counter < 1 ? prefix : "#{prefix}--#{counter}"
    end
    
    def next_value(scope, prefix)
      counter = 0
      slug    = self.with_counter(prefix, counter)
      while scope.with_cached_slug(slug).exists?
        counter += 1
        slug = self.with_counter(prefix, counter)
      end
      slug
    end
    
    def generate_uuid_slug
      UUID.new.generate
    end
    
    def last_known_slug_id(scope, slug)
      Pseudocephalopod::Slug.id_for(scope, slug)
    end
    
    def record_slug(record, slug)
      Pseudocephalopod::Slug.record_slug(record, slug)
    end
    
    def previous_slugs_for(record)
      Pseudocephalopod::Slug.previous_for(record)
    end
    
  end
  
  autoload :Scopes,      'pseudocephalopod/scopes'
  autoload :Finders,     'pseudocephalopod/finders'
  autoload :SlugHistory, 'pseudocephalopod/slug_history'
  autoload :Slug,        'pseudocephalopod/slug'
  
  require 'pseudocephalopod/active_record_methods'
  ActiveRecord::Base.extend Pseudocephalopod::ActiveRecordMethods
  
end