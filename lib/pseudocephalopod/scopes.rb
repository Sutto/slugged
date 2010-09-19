module Pseudocephalopod
  module Scopes
    
    def with_cached_slug(slug)
      where(self.cached_slug_column => slug.to_s)
    end
    
    def other_than(record)
      record.new_record? ? scoped : where("#{quoted_table_name}.#{connection.quote_column_name(:id)} != ?", record.id)
    end
    
  end
end