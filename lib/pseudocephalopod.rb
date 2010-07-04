require 'active_support'
require 'active_record'
require 'uuid'

require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/concern'

module Pseudocephalopod
  extend ActiveSupport::Autoload

  mattr_accessor :cache_key_prefix, :cache

  class << self

    def with_counter(prefix, counter = 0)
      counter < 1 ? prefix : "#{prefix}--#{counter}"
    end

    def next_value(scope, prefix)
      counter = 0
      slug    = self.with_counter(prefix, counter)
      while scope.with_cached_slug(slug).exists?
        counter += 1
        slug     = self.with_counter(prefix, counter)
      end
      slug
    end

    def uuid
      @uuid ||= UUID.new
    end

    def generate_uuid_slug
      uuid.generate
    end

    def last_known_slug_id(scope, slug)
      Pseudocephalopod::Slug.id_for(Pseudocephalopod.key_for_scope(scope), slug)
    end

    def record_slug(record, slug)
      Pseudocephalopod::Slug.record_slug(record, slug)
    end

    def previous_slugs_for(record)
      Pseudocephalopod::Slug.previous_for(record)
    end

    def remove_slug_history_for(record)
      Pseudocephalopod::Slug.remove_history_for(record)
    end

    def key_for_scope(scope)
      if scope.respond_to?(:slug_scope_key)
        scope.slug_scope_key
      elsif scope.class.respond_to?(:slug_scope_key)
        scope.class.slug_scope_key
      else
        scope.to_s
      end
    end

  end

  self.cache_key_prefix ||= "cached-slugs"

  autoload :Caching
  autoload :Scopes
  autoload :Finders
  autoload :SlugHistory
  autoload :Slug
  autoload :MemoryCache

  require 'pseudocephalopod/active_record_methods'
  ActiveRecord::Base.extend Pseudocephalopod::ActiveRecordMethods

  require 'pseudocephalopod/railtie' if defined?(Rails::Railtie)

end
