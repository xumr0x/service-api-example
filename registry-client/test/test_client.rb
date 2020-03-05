# frozen_string_literal: true

# For adding unit testing functionality.
require 'minitest/autorun'
# For mocking Redis.
require 'mock_redis'

require_relative '../client.rb'

# Please write tests for your RegistryClient code.
# As an example, one test case for service() has been given to you.
# Note: You need at least 3 test cases each for service() and register().
class TestClient < Minitest::Test
  def test_register
    # Test register here.
  end

  def test_one_service_one_instance
    # Setup Redis with records.
    r = MockRedis.new
    r.sadd('serviceA', '10.10.0.1:4567')
    r.set('10.10.0.1:4567', 'alive')

    # Configure.
    c = RegistryClient::Config.new

    service_name = 'serviceA'
    expected = '10.10.0.1:4567'

    # Query the Service Registry to retrieve address.
    client = RegistryClient::Client.new(r, c)
    got = client.service(service_name)
    assert expected == got
  end
end
