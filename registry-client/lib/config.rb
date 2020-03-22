# frozen_string_literal: true

require 'yaml'

module RegistryClient
  # Config represents configurations for the Registry Client.
  class Config
    def initialize(path = 'config.yml')
      @config = YAML.safe_load File.read(path)
    end

    def host
      @config['host'] || '127.0.0.1'
    end

    def port
      @config['port'].to_i || 6379
    end

    def password
      @config['password'] || ''
    end
  end
end
