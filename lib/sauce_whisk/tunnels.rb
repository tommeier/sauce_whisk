require 'sauce_whisk/rest_request_builder'

module SauceWhisk
  class Tunnels
    extend RestRequestBuilder

    def self.resource
      "#{SauceWhisk.username}/tunnels"
    end

    def self.all(fetch_each = false)
      all_tunnels = JSON.parse get

      unless fetch_each
        return all_tunnels
      end

      tunnels = all_tunnels.map do |tunnel|
        fetch tunnel
      end

      return tunnels
    end

    def self.stop tunnel_id
      delete tunnel_id
    end

    def self.fetch tunnel_id
      tunnel_parameters = JSON.parse get tunnel_id
      Tunnel.new tunnel_parameters
    end
  end

  class Tunnel
    attr_reader :id, :owner, :status, :host, :creation_time

    def initialize(params)
      params.each do |param, val|
        self.instance_variable_set("@#{param}", val)
      end
    end

    def stop
      SauceWhisk::Tunnels.stop self.id
    end
  end
end
