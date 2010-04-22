module Pseudocephalopod
  class Slug < ActiveRecord::Base
    set_table_name "slugs"
  
    validates_presence_of :record_id, :slug, :scope
  
    scope :ordered,    order('created_at DESC')
    scope :only_slug,  select(:slug)
    scope :for_record, lambda { |r| where(:record_id => r.id, :scope => Pseudocephalopod.key_for_scope(r)) }
  
    def self.id_for(scope, slug)
      ordered.where(:scope => scope.to_s, :slug => slug.to_s).first.try(:record_id)
    end
    
    def self.record_slug(record, slug)
      create :scope => Pseudocephalopod.key_for_scope(record), :record_id => record.id, :slug => slug.to_s
    end
    
    def self.previous_for(record)
      only_slug.ordered.for_record(record).all.map(&:slug)
    end
  
  end
end