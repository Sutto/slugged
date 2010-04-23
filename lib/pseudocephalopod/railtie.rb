module Pseudocephalopod
  class Railtie < Rails::Railtie
    
    initializer "pseudocephalopod.initialize_cache" do
      Pseudocephalopod.cache = Rails.cache if Rails.cache.present?
    end
    
  end
end