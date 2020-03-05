# frozen_string_literal: true

# For adding unit testing functionality.
require 'minitest/autorun'
# For mocking Redis.
require 'mock_redis'

# Please write tests for your RegistryClient code.
class TestClient < Minitest::Test
  def test_register; end

  def test_one_service_one_instance
    # Setup Redis with records
    r = MockRedis.new
    r.sadd('serviceA', '10.10.0.1:4567')
    r.set('10.10.0.1:4567', 'alive')

    service_name = 'serviceA'
    expected = '10.10.0.1:4567'

    client = RegistryClient::Client.new(r)
    got = client.service(service_name)
    assert expected == got
  end
end
