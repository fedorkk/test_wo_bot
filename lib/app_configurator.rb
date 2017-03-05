# frozen_string_literal: true
require 'yaml'
require './lib/db_connector'

class AppConfigurator
  def initialize
    setup_database
  end

  def token
    @token ||= YAML.load(IO.read('config/secrets.yml'))['telegram_bot_token']
  end

  def setup_database
    DbConnector.establish_connection
  end
end
