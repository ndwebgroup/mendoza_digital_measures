require 'typhoeus'
module MendozaDigitalMeasures
  class Faculty
    attr_reader :response

    def self.url_template
      "https://www.digitalmeasures.com/login/service/v4/SchemaData/INDIVIDUAL-ACTIVITIES-Business/USERNAME:%s"
    end

    def self.request_for_netid(netid)
      url = self.url_template % netid

      request = Typhoeus::Request.new(
        url,
        userpwd: ENV['MENDOZA_DIGITAL_MEASURES_USER'] + ':' + ENV['MENDOZA_DIGITAL_MEASURES_PASS']
      )
      request
    end

    def self.userpwd
    end

    def self.find_multiple_netids(*netids)
      hydra = Typhoeus::Hydra.hydra
      responses = []

      netids.each do |netid|
        req = request_for_netid(netid)

        req.on_complete do |response|
          if response.success?
            puts "Success with #{netid}"
            responses << new(netid, response)
          elsif response.timed_out?
            puts "Timed out on #{netid}"
          else
            puts "HTTP request failed: #{response.code}"
          end
        end

        hydra.queue(req)
      end

      hydra.run

      return responses
    end

    def initialize(netid, response)
      @netid = netid
      @response = response
    end

    def parsed_xml
      @parsed_xml ||= parse_xml!
    end

    private

    def parse_xml!
      Nokogiri.parse response.response_body
    end
  end
end
