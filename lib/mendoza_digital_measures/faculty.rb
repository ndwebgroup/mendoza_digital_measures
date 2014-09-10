require 'typhoeus'
require 'nokogiri'

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
        userpwd: ENV['MENDOZA_DIGITAL_MEASURES_USER_AUTH']
      )
      request
    end

    def self.find_multiple_netids(*netids)
      hydra = Typhoeus::Hydra.hydra
      responses = []

      netids.each do |netid|
        req = request_for_netid(netid)

        req.on_complete do |response|
          if response.success?
            responses << new(netid, response)
          elsif response.timed_out?
            responses << new(netid, nil)
            log "#{netid} not found"
          else
            responses << new(netid, nil)
            log "#{netid} caused an error"
          end
        end

        hydra.queue(req)
      end

      hydra.run

      responses
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

    def self.log(msg)
      msg = "[digital measures] #{msg}"
      if defined? Rails
        Rails.logger.info msg
      else
        puts msg
      end
    end
  end
end
