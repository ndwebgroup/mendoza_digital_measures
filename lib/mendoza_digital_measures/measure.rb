require 'typhoeus'
require 'nokogiri'

module MendozaDigitalMeasures
  class Measure

    attr_reader(
      :first_name,
      :last_name,
      :middle_name,
      :email,
      :veteran_status,
      :website,
      :bio,
      :room_number,
      :phone,
      :title,
      :endowed_position,
      :areas_of_expertise,
      :education,
      :publications,
      :books,
      :presentations,
      :teaching
    )

    def initialize(xml)
      measure = Nokogiri.parse xml
      measure.remove_namespaces!

      @first_name = measure.xpath("//PCI/FNAME").first.text.strip

      @last_name = measure.xpath("//PCI/LNAME").first.text.strip
      @middle_name = measure.xpath("//PCI/MNAME").first.text.strip
      @email = measure.xpath("//PCI/EMAIL").first.text.strip
      @website = measure.xpath("//PCI/WEBSITE").first.text.strip
      @bio = measure.xpath("//PCI/BIO").first.text.strip
      @room_number = measure.xpath("//PCI/ROOMNUM").first.text.strip
      @phone = [measure.xpath("//PCI/OPHONE1").first.text.strip, measure.xpath("//PCI/OPHONE2").first.text.strip, measure.xpath("//PCI/OPHONE3").first.text.strip ].join("-")
      @title =  measure.xpath("//ADMIN/RANK").first.text.strip
      @endowed_position = measure.xpath("//PCI/ENDPOS").first.text.strip

      @areas_of_expertise = find_areas_of_expertise(measure)
      @education = find_education(measure)
      @publications = find_publications(measure)
      @books = find_books(measure)
      @presentations = find_presentations(measure)
      @teaching = find_teaching(measure)
    end



  private

    def find_areas_of_expertise(measure)
      expertisei = []
        measure.xpath("//PCI/PCI_EXPERTISE/EXPERTISE").each do | e |
          expertisei << e.text
        end
      return expertisei
    end

    def find_education(measure)
      educations = []
      measure.xpath("//EDUCATION").each do | e |
        educations << "#{e.xpath("DEG").first.text.strip}, #{e.xpath("SCHOOL").first.text.strip}"
      end
      return educations
    end


    def find_teaching(measure)
      teachings = []
      measure.xpath("//SCHTEACH").each do | e |
        teachings << "#{e.xpath("TITLE").first.text.strip}"
      end
      teachings.uniq!
      return teachings
    end

    def find_publications(measure)
      items = []
      measure.xpath("//INTELLCONT").each do | n |
        if n.xpath("CONTYPE").first.text.strip == "Journal Articles, Refereed"
          link = "<a href=\"#{n.xpath("WEB_ADDRESS").first.text.strip}\">\"#{n.xpath("TITLE").first.text.strip}\"</a>,"
          #with = "()"
          where = "To appear in <i>#{n.xpath("PUBLISHER").first.text.strip}</i>, #{n.xpath("VOLUME").first.text.strip}, #{n.xpath("DTY_PUB").first.text.strip}."
          items << [link, where].join(" ")
        end
      end
      return items
    end

    def find_books(measure)
      items = []
      measure.xpath("//INTELLCONT").each do | n |
        if n.xpath("CONTYPE").first.text.strip == "Book, Scholarly-Contributed Chapter"
          items << "#{n.xpath("TITLE").first.text.strip}"
        end
      end
      return items
    end

    def find_presentations(measure)
      items = []
      measure.xpath("//PRESENT").each do | n |
        items << "#{n.xpath("PRESENT_AUTH/FNAME").first.text.strip} #{n.xpath("PRESENT_AUTH/LNAME").first.text.strip}, #{n.xpath("NAME").first.text.strip}, #{n.xpath("ORG").first.text.strip}, #{n.xpath("LOCATION").first.text.strip}, \"#{n.xpath("TITLE").first.text.strip}\" (#{n.xpath("DTM_DATE").first.text.strip} #{n.xpath("DTD_DATE").first.text.strip}, #{n.xpath("DTY_DATE").first.text.strip})."
      end
      return items
    end


  end

end
