# frozen_string_literal: true
require 'active_record'

class DbConnector
  class << self
    def establish_connection
      configuration = YAML.load(IO.read(database_config_path))

      ActiveRecord::Base.establish_connection(configuration)
    end

    private

    def database_config_path
      'config/database.yml'
    end
  end
end
