module Pseudocephalopod
  module SlugHistory
   
    def self.included(parent)
      parent.class_eval do
        include InstanceMethods
        extend  ClassMethods
        after_save :check_slug_change
      end
    end
   
    module InstanceMethods
      
      def previous_slugs
        Pseudocephalopod.previous_slugs_for(self)
      end
      
      protected
      
      def check_slug_change
        return unless send(:"#{self.cached_slug_column}_changed?")
        value = send(:"#{self.cached_slug_column}_was")
        Pseudocephalopod.record_slug(self, value) if value.present?
      end
      
    end
    
    module ClassMethods
      
      def find_using_slug_history(slug, options = {})
        id = Pseudocephalopod.last_known_slug_id(self.slug_scope, slug)
        id.present? ? find_by_id(id, options) : nil
      end
      
      def slug_scope
        table_name
      end
      
    end
    
  end
end