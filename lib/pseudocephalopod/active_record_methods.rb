module Pseudocephalopod
  module ActiveRecordMethods
    
    def is_sluggable(source = :name, options = {})
      extend  ClassMethods
      include InstanceMethods
      extend Pseudocephalopod::Scopes
      extend Pseudocephalopod::Finders
      options.symbolize_keys!
      # Define the attributes
      class_attribute :cached_slug_column, :slug_source, :slug_source_convertor,
                      :default_uuid_slug, :store_slug_history, :sync_slugs
      # Set attribute values
      set_slug_convertor options[:convertor]
      self.slug_source        = source.to_sym
      self.cached_slug_column = (options[:slug_column] || :cached_slug).to_sym
      self.default_uuid_slug  = !!options.fetch(:uuid, true)
      self.store_slug_history = !!options.fetch(:history, true)
      self.sync_slugs         = !!options.fetch(:sync, true)
      alias_method :to_param, :to_slug if !!options.fetch(:to_param, true)
      include Pseudocephalopod::SlugHistory if self.store_slug_history
      before_validation :autogenerate_slug
    end
    
    module InstanceMethods
      
      def to_slug
        cached_slug.present? ? cached_slug : id.to_s
      end
      
      def generate_slug
        slug_value = send(self.slug_source)
        slug_value = self.slug_source_convertor.call(slug_value) if slug_value.present?
        if slug_value.present?
          scope = self.class.other_than(self)
          slug_value = Pseudocephalopod.next_value(scope, slug_value)
          write_attribute self.cached_slug_column, slug_value
        elsif self.default_uuid_slug
          write_attribute self.cached_slug_column, Pseudocephalopod.generate_uuid_slug
        else
          write_attribute self.cached_slug_column, nil
        end
      end
      
      def generate_slug!
        generate_slug
        save :validate => false
      end
      
      def autogenerate_slug
        generate_slug if should_generate_slug?
      end
      
      def should_generate_slug?
        send(self.cached_slug_column).blank? || (self.sync_slugs && send(:"#{self.slug_source}_changed?"))
      end
      
    end
    
    module ClassMethods
      
      def update_all_slugs!
        find_each { |r| r.generate_slug! }
      end
      
      protected
      
      def set_slug_convertor(convertor)
        if convertor.present?
          if convertor.is_a?(Symbol)
            self.slug_source_convertor = proc { |r| r.try(convertor) }
          elsif convertor.respond_to?(:call)
            self.slug_source_convertor = convertor
          end
        else
          if "".respond_to?(:to_url)
            self.slug_source_convertor = proc { |r| r.to_s.to_url }
          else
            self.slug_source_convertor = proc { |r| ActiveSupport::Multibyte::Chars.new(r.to_s).parameterize }
          end
        end
      end
      
    end    
  end
end