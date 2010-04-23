require 'rails/generators'

module Pseudocephalopod
  module Generators
    class Base < Rails::Generators::NamedBase
  
      def self.source_root
        @_pseudocephalopod_generator_source_root ||= begin
          File.expand_path(File.join("pseudocephalopod", generator_name, "templates"), File.dirname(__FILE__))
        end
      end
  
    end
  end
end