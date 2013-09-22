module Slugged
  module Finders
    
    def find_using_slug(slug)
      slug = slug.to_s
      value = nil
      value ||= find_by_id(slug.to_i) if slug =~ /\A\d+\Z/
      value ||= with_cached_slug(slug).first
      value ||= find_using_slug_history(slug) if use_slug_history
      value.found_via_slug = slug if value.present?
      value
    end
    
    def find_using_slug!(slug)
      find_using_slug(slug) or raise ActiveRecord::RecordNotFound
    end
    
  end
end
