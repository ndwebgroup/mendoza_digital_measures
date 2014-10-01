require 'typhoeus'
require 'nokogiri'
require_relative 'faculty'

module DigitalMeasures
  class Index

    def self.url_template
      'https://www.digitalmeasures.com/login/service/v4/SchemaIndex/INDIVIDUAL-ACTIVITIES-Business/'
    end

    def self.all
      url = self.url_template
      request = Typhoeus::Request.new(
        url,
        userpwd: ENV['MENDOZA_DIGITAL_MEASURES_USER_AUTH']
      )
      response = request.run
      doc = Nokogiri.parse(response.response_body)
      netid_list = self.usernames(doc)
    end

    def initialize
      @response = Typhoeus.get(
        self.url_template,
        userpwd: ENV['MENDOZA_DIGITAL_MEASURES_USER_AUTH']
      )
    end

    def self.usernames(xml)
      xml.xpath('//Index[@indexKey="USERNAME"]/IndexEntry').map { |e|
        e.attributes["entryKey"].value
      }
    end
  end
end
