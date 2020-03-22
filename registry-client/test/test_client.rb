# frozen_string_literal: true

# For adding unit testing functionality.
require 'minitest/autorun'
# For mocking Redis.
require 'mock_redis'

require_relative '../lib/client.rb'

# Please write tests for your RegistryClient code.
# As an example, one test case for service() has been given to you.
# Note: You need at least 3 test cases each for service() and register().
class TestClient < Minitest::Test
  # Test register here.
  describe 'test service register' do
    it 'registering 1 service' do
    end
  end

  describe 'test service discovery' do
    it '1 service running on 1 instance' do
      # Setup Redis with records.
      r = MockRedis.new
      r.sadd('serviceA', '10.10.0.1:4567')
      r.set('10.10.0.1:4567', 'alive')

      # Load configs.
      c = RegistryClient::Config.new('lib/config.yml')

      service_name = 'serviceA'
      expected = '10.10.0.1:4567'

      # Query the Service Registry to retrieve address.
      client = RegistryClient::Client.new(config: c, client: r)
      got = client.service(service_name)
      assert expected == got
    end
  end
end
