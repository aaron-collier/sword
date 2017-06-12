require 'rails/generators'

class Sword::ConfigGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  def create_initializer_config_file
    copy_file 'config/sword.rb', 'config/initializers/sword.rb'
    copy_file 'config/sword_ingest.yml', 'config/sword_ingest.yml'
  end
end
