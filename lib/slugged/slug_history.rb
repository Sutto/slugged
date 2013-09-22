module Slugged
  module SlugHistory
    extend ActiveSupport::Concern
    
    included do
      after_save :record_slug_changes
      after_destroy :remove_slug_history!
    end

    def previous_slugs
      Slugged.previous_slugs_for(self)
    end
    
    def remove_slug_history!
      Slugged.remove_slug_history_for(self)
    end
    
    protected
    
    def record_slug_changes
      slug_column = self.cached_slug_column
      return unless send(:"#{slug_column}_changed?")
      value = send(:"#{slug_column}_was")
      Slugged.record_slug(self, value) if value.present?
    end
    
    module ClassMethods
      
      def find_using_slug_history(slug)
        id = Slugged.last_known_slug_id(self, slug)
        id.present? ? find_by_id(id) : nil
      end
      
    end
    
  end
end
