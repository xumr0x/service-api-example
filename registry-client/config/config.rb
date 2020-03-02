require 'yaml'

# Config represents configurations for the Registry Client.
class Config
  def initialize
    @config = YAML.safe_load File.read('config.yml')
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
