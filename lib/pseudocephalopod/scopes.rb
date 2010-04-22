module Pseudocephalopod
  module Scopes
    
    def with_cached_slug(slug)
      where(self.cached_slug_column => slug.to_s)
    end
    
    def other_than(record)
      record.new_record? ? self : where("#{quoted_table_name}.id != ?", record.id)
    end
    
    def with_stored_slug(slug)
      
    end
    
  end
end