require 'typhoeus'
require 'nokogiri'

module MendozaDigitalMeasures
  class Measure

    def initialize(xml)
      @measure = Nokogiri.parse xml
      @measure.remove_namespaces!
    end

    def to_hash
      @faculty = {
        first_name: @measure.xpath("//PCI/FNAME").first.text,
        last_name: @measure.xpath("//PCI/LNAME").first.text,
        middle_name: @measure.xpath("//PCI/MNAME").first.text,
        email: @measure.xpath("//PCI/EMAIL").first.text,
        bio: @measure.xpath("//PCI/BIO").first.text,
        room_number: @measure.xpath("//PCI/ROOMNUM").first.text,
        phone: [@measure.xpath("//PCI/OPHONE1").first.text, @measure.xpath("//PCI/OPHONE2").first.text, @measure.xpath("//PCI/OPHONE3").first.text ].join("-"),
        title: "",
        endowed_position: @measure.xpath("//PCI/ENDPOS").first.text ,

        areas_of_expertise: areas_of_expertise,
        education: education,
        teaching: teaching
      }
    end



    def areas_of_expertise
      expertisei = []
      @measure.xpath("//PCI/PCI_EXPERTISE/EXPERTISE").each do | e |
        expertisei << e.text
      end
      return expertisei
    end

    def education
    end


    def teaching
      []
    end


  end

end
