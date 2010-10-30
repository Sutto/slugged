module Slugged
  module Finders
    
    def find_using_slug(slug, options = {})
      slug = slug.to_s
      value = nil
      value ||= find_by_id(slug.to_i, options) if slug =~ /\A\d+\Z/
      value ||= with_cached_slug(slug).first(options)
      value ||= find_using_slug_history(slug, options) if use_slug_history
      value.found_via_slug = slug if value.present?
      value
    end
    
    def find_using_slug!(slug, options = {})
      find_using_slug(slug, options) or raise ActiveRecord::RecordNotFound
    end
    
  end
end