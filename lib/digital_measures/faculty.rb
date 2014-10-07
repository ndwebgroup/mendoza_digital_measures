require 'typhoeus'
require 'nokogiri'

module DigitalMeasures
  class Faculty

    attr_reader(
      :first_name,
      :last_name,
      :middle_name,
      :prefix,
      :suffix,
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
      :teaching,
      :working_papers
    )

    def initialize(xml)
      measure = Nokogiri.parse xml
      measure.remove_namespaces!

      @first_name = measure.xpath("//PCI/FNAME").first.text.strip

      @last_name = measure.xpath("//PCI/LNAME").first.text.strip
      @middle_name = measure.xpath("//PCI/MNAME").first.text.strip
      @prefix = measure.xpath("//PCI/PREFIX").first.text.strip
      @suffix = measure.xpath("//PCI/SUFFIX").first.text.strip
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
      @working_papers = find_working_papers(measure)
    end


    def self.url_template
      "https://www.digitalmeasures.com/login/service/v4/SchemaData/INDIVIDUAL-ACTIVITIES-Business/USERNAME:%s"
    end

    def self.find_netid(netid)
      url = self.url_template % netid

      request = Typhoeus::Request.new(
        url,
        userpwd: ENV['MENDOZA_DIGITAL_MEASURES_USER_AUTH']
      )
      request
    end

    def self.find_netids(netids)

      hydra = Typhoeus::Hydra.hydra
      responses = []

      netids.each do |netid|
        req = find_netid(netid)

        req.on_complete do |response|
          if response.success?
            begin
              responses << new(response.response_body)
            rescue => e
              log "could not create dm record for netid #{netid}"
              log e
              end

          elsif response.timed_out?
            #responses << new(nil)
            log "#{netid} not found due to timeout"
          else
            #responses << new(nil)
            log "#{netid} caused an error"
          end
        end

        hydra.queue(req)
      end

      hydra.run

      responses
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
        if e.xpath("DEG").first.text.strip == "Other"
          degree = e.xpath("DEGOTHER").first.text.strip
        else
          degree = e.xpath("DEG").first.text.strip
        end
        educations << "#{degree}, #{e.xpath("SCHOOL").first.text.strip}"
      end
      return educations
    end


    def find_teaching(measure)
      #limit to 3 years
      teachings = []
      measure.xpath("//SCHTEACH").each do | e |
        unless e.xpath("WEBPAGE_INCLUDE").first.text.strip == "No"  && e.xpath("TYY_TERM").first.text.strip.to_i == (DateTime.now.year - 3).to_i
          teachings << "#{e.xpath("TITLE").first.text.strip}"
        end
      end
      teachings.uniq!
      return teachings
    end

    def find_publications(measure)
      #marked for web
      contypes = ["Journal Articles, Refereed", "Journal Articles", "Non-Refereed", "Other"]
      items = []
      measure.xpath("//INTELLCONT").each do | n |
        if contypes.include? n.xpath("CONTYPE").first.text.strip
          link = "<a href=\"#{n.xpath("WEB_ADDRESS").first.text.strip}\">\"#{n.xpath("TITLE").first.text.strip}\"</a>,"
          #<xsl:if test="string-length(t:PAGENUM) > 0">
          if n.xpath("STATUS").first.text.strip == "Accepted"
            where_preface = "To appear in "
          else
            where_preface = ""
          end
          where = "#{where_preface}<i>#{n.xpath("PUBLISHER").first.text.strip}</i>, #{n.xpath("VOLUME").first.text.strip}, #{n.xpath("DTY_PUB").first.text.strip}."
          items << [link, where].join(" ")
        end
      end
      return items
    end

    def find_books(measure)

      contypes = ["Book, Scholarly" "Book, Textbook-New" ,"Book, Textbook-Revised", "Book, Referred Article",  "Book, Review", "Book, Scholarly-Contributed Chapter"]
      items = []
      measure.xpath("//INTELLCONT").each do | n |
        if contypes.include?(n.xpath("CONTYPE").first.text.strip) && n.xpath("WEBPAGE_INCLUDE").first.text.strip != "No"
          items << "#{n.xpath("TITLE").first.text.strip}"
        end
      end
      return items
    end

    def find_presentations(measure)
      #PRESENT[t:WEBPAGE_INCLUDE='Yes']) > 0">
      items = []
      measure.xpath("//PRESENT").each do | n |
        if n.xpath("WEBPAGE_INCLUDE").first.text.strip == "Yes"
          items << "#{n.xpath("PRESENT_AUTH/FNAME").first.text.strip} #{n.xpath("PRESENT_AUTH/LNAME").first.text.strip}, #{n.xpath("NAME").first.text.strip}, #{n.xpath("ORG").first.text.strip}, #{n.xpath("LOCATION").first.text.strip}, \"#{n.xpath("TITLE").first.text.strip}\" (#{n.xpath("DTM_DATE").first.text.strip} #{n.xpath("DTD_DATE").first.text.strip}, #{n.xpath("DTY_DATE").first.text.strip})."
        end
      end
      return items
    end

    def find_working_papers(measure)
      items = []
      measure.xpath("//RESPROG").each do | n |
        if n.xpath("WEBPAGE_INCLUDE").first.text.strip == "Yes"
          texties = []
          n.xpath("RESPROG_COLL").each do | c |
            texties << c.xpath("NAME").first.text.strip
          end

          unless n.xpath("URL").text.strip.blank? || n.xpath("URL").text.strip == "http://"
            texties << "\"<a href=\"#{n.xpath("URL").first.text.strip}\">#{n.xpath("TITLE").first.text.strip}</a>.\""
          else
            texties << "\"#{n.xpath("TITLE").first.text.strip}.\""
          end

          items << texties.join(", ")
        end
      end
      return items
    end

    def self.log(msg)
      msg = "[digital measures] #{msg}"
      if defined? Rails
        Rails.logger.info msg
      else
      end
        puts msg
    end
  end

end
