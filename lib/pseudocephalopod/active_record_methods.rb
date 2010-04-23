module Pseudocephalopod
  module ActiveRecordMethods
    AR_CLASS_ATTRIBUTE_NAMES = %w(cached_slug_column slug_source slug_convertor_proc default_uuid_slug use_slug_history sync_slugs slug_scope use_slug_cache use_slug_to_param).map(&:to_sym)
    
    def is_sluggable(source = :name, options = {})
      options.symbolize_keys!
      class_attribute *AR_CLASS_ATTRIBUTE_NAMES
      attr_accessor   :found_via_slug
      # Load extensions
      extend  ClassMethods
      include InstanceMethods
      extend Pseudocephalopod::Scopes
      extend Pseudocephalopod::Finders
      self.slug_source = source.to_sym
      set_slug_options options
      alias_method :to_param, :to_slug      if use_slug_to_param
      include Pseudocephalopod::SlugHistory if use_slug_history
      include Pseudocephalopod::Caching     if use_slug_cache
      before_validation :autogenerate_slug
    end
    
    module InstanceMethods
      
      def to_slug
        cached_slug.present? ? cached_slug : id.to_s
      end
      
      def generate_slug
        slug_value = send(self.slug_source)
        slug_value = self.slug_convertor_proc.call(slug_value) if slug_value.present?
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
      
      def set_slug_options(options)
        set_slug_convertor options[:convertor]
        self.cached_slug_column = (options[:slug_column] || :cached_slug).to_sym
        self.slug_scope         = options[:scope]
        self.default_uuid_slug  = !!options.fetch(:uuid, true)
        self.sync_slugs         = !!options.fetch(:sync, true)
        self.use_slug_cache     = !!options.fetch(:use_cache, true)
        self.use_slug_to_param  = !!options.fetch(:to_param, true)
        self.use_slug_history   = !!options.fetch(:history, Pseudocephalopod::Slug.usable?)
      end
      
      def set_slug_convertor(convertor)
        if convertor.present?
          unless convertor.respond_to?(:call)
            convertor_key = convertor.to_sym
            convertor     = proc { |r| r.try(convertor_key) }
          end
          self.slug_convertor_proc = convertor
        else
          self.slug_convertor_proc = proc do |slug|
            slug.respond_to?(:to_url) ? slug.to_url : ActiveSupport::Multibyte::Chars.new(slug.to_s).parameterize
          end
        end
      end
      
    end    
  end
end