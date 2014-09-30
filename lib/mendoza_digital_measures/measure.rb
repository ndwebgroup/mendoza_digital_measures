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
        first_name: @measure.xpath("//PCI/FNAME").first.text.strip,
        last_name: @measure.xpath("//PCI/LNAME").first.text.strip,
        middle_name: @measure.xpath("//PCI/MNAME").first.text.strip,
        email: @measure.xpath("//PCI/EMAIL").first.text.strip,
        website: @measure.xpath("//PCI/WEBSITE").first.text.strip,
        bio: @measure.xpath("//PCI/BIO").first.text.strip,
        room_number: @measure.xpath("//PCI/ROOMNUM").first.text.strip,
        phone: [@measure.xpath("//PCI/OPHONE1").first.text.strip, @measure.xpath("//PCI/OPHONE2").first.text.strip, @measure.xpath("//PCI/OPHONE3").first.text.strip ].join("-"),
        title:  @measure.xpath("//ADMIN/RANK").first.text.strip,
        endowed_position: @measure.xpath("//PCI/ENDPOS").first.text.strip ,

        areas_of_expertise: areas_of_expertise,
        education: education,
        publications: publications,
        books: books,
        presentations: presentations,
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
        educations << "#{e.xpath("DEG").first.text.strip}, #{e.xpath("SCHOOL").first.text.strip}"
      end
      return educations
    end


    def teaching
      teachings = []
      @measure.xpath("//SCHTEACH").each do | e |
        teachings << "#{e.xpath("TITLE").first.text.strip}"
      end
      teachings.uniq!
      return teachings
    end

    def publications
      items = []
      @measure.xpath("//INTELLCONT").each do | n |
        if n.xpath("CONTYPE").first.text.strip == "Journal Articles, Refereed"
          items << "#{n.xpath("TITLE").first.text.strip}"
        end
      end
      return items
    end

    def books
      items = []
      @measure.xpath("//INTELLCONT").each do | n |
        if n.xpath("CONTYPE").first.text.strip == "Book, Scholarly-Contributed Chapter"
          items << "#{n.xpath("TITLE").first.text.strip}"
        end
      end
      return items
    end

    def presentations
      items = []
      @measure.xpath("//PRESENT").each do | n |
        items << "#{n.xpath("PRESENT_AUTH/FNAME").first.text.strip} #{n.xpath("PRESENT_AUTH/LNAME").first.text.strip}, #{n.xpath("NAME").first.text.strip}, #{n.xpath("ORG").first.text.strip}, #{n.xpath("LOCATION").first.text.strip}, \"#{n.xpath("TITLE").first.text.strip}\" (#{n.xpath("DTM_DATE").first.text.strip} #{n.xpath("DTD_DATE").first.text.strip} #{n.xpath("DTY_DATE").first.text.strip})."
      end
      return items
    end


  end

end
