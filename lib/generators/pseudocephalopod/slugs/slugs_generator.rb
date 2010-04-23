require 'generators/pseudocephalopod'

module Pseudocephalopod
  module Generators
    class SlugsGenerator < Base
      
      def create_migration_file
        migration_template "migration.rb", "db/migrate/create_pseudocephalopod_slugs.rb"
      end
      
    end
  end
end