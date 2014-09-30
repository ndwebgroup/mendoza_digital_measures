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
        website: @measure.xpath("//PCI/WEBSITE").first.text,
        bio: @measure.xpath("//PCI/BIO").first.text,
        room_number: @measure.xpath("//PCI/ROOMNUM").first.text,
        phone: [@measure.xpath("//PCI/OPHONE1").first.text, @measure.xpath("//PCI/OPHONE2").first.text, @measure.xpath("//PCI/OPHONE3").first.text ].join("-"),
        title:  @measure.xpath("//ADMIN/RANK").first.text,
        endowed_position: @measure.xpath("//PCI/ENDPOS").first.text ,

        areas_of_expertise: areas_of_expertise,
        education: education,
        publications: publications,
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
      educations = []
      @measure.xpath("//EDUCATION").each do | e |
        educations << "#{e.xpath("DEG").first.text}, #{e.xpath("SCHOOL").first.text}"
      end
      return educations
    end


    def teaching
      teachings = []
      @measure.xpath("//SCHTEACH").each do | e |
        teachings << "#{e.xpath("TITLE").first.text}"
      end
      teachings.uniq!
      return teachings
    end

    def publications
      items = []
      @measure.xpath("//INTELLCONT").each do | n |
        items << "#{n.xpath("TITLE").first.text}"
      end
      return items
    end


  end

end
