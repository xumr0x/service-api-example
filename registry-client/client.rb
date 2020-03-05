# frozen_string_literal: true

require 'redis'
require_relative 'config.rb'

# In this file you need to implement a registry client.
module RegistryClient
  # Client is a registry client that talks to a Redis service registry.
  # It has two core functions:
  #   - Register itself to the registry when the service is up.
  #   - Query the registry for addresses of services that it wants to talk to.
  #
  # Example use:
  #   require_relative '../registry-client/client.rb'
  #   config = RegistryClient::Config.new('config.yml')
  #   client = RegistryClient::Client.new(
  #     Redis.new(
  #       host: config.host,
  #       port: config.port,
  #       password: config.password
  #     )
  #   )
  #   service_api = client.service('service-api')
  #
  # @param config <tt>RegistryClient::Config</tt>
  class Client
    def initialize(redis_client)
      @client = redis_client
    end

    # Register registers itself to the Service Registry.
    #
    # This method does 2 things:
    #
    # First, it registers itself to the corresponding service set via
    # `SADD serviceName "address"`. A service set is a set of addresses
    # of instances running the service.
    # Then, it registers itself by setting its status to "alive" that expires
    # every 30 seconds via `SET address "alive" EX 30`.
    # Note: these two steps are wrapped in a Transaction to ensure consistency.
    #
    # Second, it needs to re-register itself every 30 seconds via `SET ...`
    # (in the background) to the registry to *prove* that this service is still
    # alive.
    # If the registry does not hear back from this service within this time
    # period, it will be declared *dead*.
    #
    # This is what happens in Redis,
    #   // An instance running Service A registers itself.
    #   SADD serviceA "10.10.10.11:4567"
    #   SET 10.10.10.11:4567 "alive" EX 30
    #   // Another instance running Service A registers itself.
    #   SADD serviceA "45.21.34.12:4567"
    #   SET 45.21.34.12:4567 "alive" EX 30
    #
    # @param name serviceName
    # @param host ip v4 address
    # @param port
    def register(name:, host:, port:)
      raise 'not implemented'
    end

    # Service() returns the address of an instance running a given service.
    #
    # Internally, the client first asks for the list of instances running
    # a particular service. Then, it picks one of the instances (ip addresses)
    # using a load balancing strategy.
    # Before returning the address, it checks if the address is still *alive*
    # via `EXISTS ...`.
    # If it is alive, return the address. Otherwise, picks another address.
    # Throws an Exception if no suitable address is found.
    #
    # This is what happens in Redis,
    #   // Lookup instances running serviceA.
    #   SMEMBERS serviceA
    #     1) "10.10.10.3:4567"
    #     2) "10.10.10.1:4567"
    #     3) "10.10.10.2:4567"
    #   // Pick an instance and checks if it is alive.
    #   EXISTS 10.10.10.1:4567
    #     (integer) 1   // it is alive!!
    #
    # @param name serviceName
    def service(name:)
      raise 'not implemented'
    end
  end
end
