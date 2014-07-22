require 'typhoeus'
require 'nokogiri'

module MendozaDigitalMeasures
  class FacultyIndex
    def url_template
      'https://www.digitalmeasures.com/login/service/v4/SchemaIndex/INDIVIDUAL-ACTIVITIES-Business/' 
    end

    def self.all
      Faculty.find_multiple_netids(usernames)
    end

    def self.usernames
      new.usernames
    end

    def initialize
      @response = Typhoeus.get(
        url_template,
        userpwd: ENV['MENDOZA_DIGITAL_MEASURES_USER_AUTH']
      )
    end

    def response
      @response
    end

    def parsed
      @parsed ||= Nokogiri.parse(response.response_body)
    end

    def usernames
      parsed.xpath('//Index[@indexKey="USERNAME"]/IndexEntry').map {|e| e.attributes["entryKey"].value }
    end
  end
end
