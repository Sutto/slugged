module Slugged
  class Railtie < Rails::Railtie
    
    initializer "slugged.initialize_cache" do
      Slugged.cache = Rails.cache if Rails.cache.present?
    end
    
  end
end