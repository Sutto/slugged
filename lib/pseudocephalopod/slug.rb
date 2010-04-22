module Pseudocephalopod
  class Slug < ActiveRecord::Base
    set_table_name "slugs"
  
    def self.id_for(scope, slug)
      order('created_at DESC').where(:scope => scope.to_s, :slug => slug.to_s).first.try(:record_id)
    end
    
    def self.record_slug(record, slug)
      create :scope => record.class.slug_scope.to_s, :record_id => record.id.to_i, :slug => slug.to_s
    end
    
    def self.previous_for(record)
      select(:slug).order('created_at DESC').where(:record_id => record.id.to_i, :scope => record.class.slug_scope.to_s).map(&:slug)
    end
  
  end
end