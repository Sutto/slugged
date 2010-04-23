module Pseudocephalopod
  class Slug < ActiveRecord::Base
    set_table_name "slugs"
  
    validates_presence_of :record_id, :slug, :scope
  
    scope :ordered,    order('created_at DESC')
    scope :only_slug,  select(:slug)
    scope :for_record, lambda { |r| where(:record_id => r.id, :scope => Pseudocephalopod.key_for_scope(r)) }
    scope :for_slug,   lambda { |scope, slug| where(:scope=> scope.to_s, :slug => slug.to_s)}
  
    def self.id_for(scope, slug)
      ordered.for_slug(scope, slug).first.try(:record_id)
    end
    
    def self.record_slug(record, slug)
      scope = Pseudocephalopod.key_for_scope(record)
      # Clear slug history in this scope before recording the new slug
      for_slug(scope, slug).delete_all
      create :scope => scope, :record_id => record.id, :slug => slug.to_s
    end
    
    def self.previous_for(record)
      ordered.only_slug.for_record(record).all.map(&:slug)
    end
    
    def self.remove_history_for(record)
      for_record(record).delete_all
    end
  
    def self.usable?
      table_exists? rescue false
    end
  
  end
end