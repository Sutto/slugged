module Pseudocephalopod
  module ActiveRecordMethods
    
    def is_sluggable(source = :name, options = {})
      extend  ClassMethods
      include InstanceMethods
      extend Pseudocephalopod::Scopes
      extend Pseudocephalopod::Finders
      options.symbolize_keys!
      # Define the attributes
      class_attribute :cached_slug_column, :slug_source, :string_to_slug_base,
                      :default_uuid_slug, :use_slug_history, :sync_slugs, :slug_scope,
                      :use_slug_cache, :use_slug_to_param
      attr_accessor   :found_via_slug
      # Set attribute values
      set_slug_convertor options[:convertor]
      self.slug_source        = source.to_sym
      self.cached_slug_column = (options[:slug_column] || :cached_slug).to_sym
      self.slug_scope         = options[:scope]
      self.default_uuid_slug  = !!options.fetch(:uuid, true)
      self.sync_slugs         = !!options.fetch(:sync, true)
      self.use_slug_cache     = !!options.fetch(:use_cache, true)
      self.use_slug_to_param  = !!options.fetch(:to_param, true)
      self.use_slug_history   = !!options.fetch(:history, Pseudocephalopod::Slug.usable?)
      alias_method :to_param, :to_slug      if self.use_slug_to_param
      # Automatically mixin the correct module for each mixin.
      include Pseudocephalopod::SlugHistory if self.use_slug_history
      include Pseudocephalopod::Caching     if self.use_slug_cache
      before_validation :autogenerate_slug
    end
    
    module InstanceMethods
      
      def to_slug
        cached_slug.present? ? cached_slug : id.to_s
      end
      
      def generate_slug
        slug_value = send(self.slug_source)
        slug_value = self.string_to_slug_base.call(slug_value) if slug_value.present?
        if slug_value.present?
          scope = self.class.other_than(self).slug_scope_relation(self)
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
      
      def has_better_slug?
        found_via_slug.present? && found_via_slug != to_slug
      end
      
      def slug_scope_key(nested_scope = [])
        self.class.slug_scope_key(nested_scope)
      end
      
    end
    
    module ClassMethods
      
      def update_all_slugs!
        find_each { |r| r.generate_slug! }
      end
      
      def slug_scope_key(nested_scope = [])
        ([table_name, slug_scope] + Array(nested_scope)).flatten.compact.join("|")
      end
      
      def slug_scope_relation(record)
        has_slug_scope? ? where(slug_scope => record.send(slug_scope)) : unscoped
      end
      
      protected
      
      def has_slug_scope?
        self.slug_scope.present?
      end
      
      def set_slug_convertor(convertor)
        if convertor.present?
          if convertor.is_a?(Symbol)
            self.string_to_slug_base = proc { |r| r.try(convertor) }
          elsif convertor.respond_to?(:call)
            self.string_to_slug_base = convertor
          end
        else
          if String.instance_methods.detect { |im| im.to_sym == :to_url }.present?
            self.string_to_slug_base = proc { |r| r.to_s.to_url }
          else
            self.string_to_slug_base = proc { |r| ActiveSupport::Multibyte::Chars.new(r.to_s).parameterize }
          end
        end
      end
      
    end    
  end
end