require 'typhoeus'
require 'nokogiri'

module DigitalMeasures
  class Faculty

    attr_reader(
      :netid,
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
      :working_papers,
      :articles_and_chapters,
      :cv_url
    )

    def initialize(xml)
      measure = Nokogiri.parse xml
      measure.remove_namespaces!
      @netid = measure.xpath("//Record").attr("username").value

          #single item valus (strings)
      @first_name = get_value_for(measure, "PCI/FNAME")
      @last_name = get_value_for(measure, "PCI/LNAME")
      @middle_name = get_value_for(measure, "PCI/MNAME")
      @prefix = get_value_for(measure, "PCI/PREFIX")
      @suffix = get_value_for(measure, "PCI/SUFFIX")
      @email = get_value_for(measure, "PCI/EMAIL")
      @website = get_value_for(measure, "PCI/WEBSITE")
      @bio = get_value_for(measure, "PCI/BIO")
      @room_number = get_value_for(measure, "PCI/ROOMNUM")
      @phone = [get_value_for(measure, "PCI/OPHONE1"), get_value_for(measure, "PCI/OPHONE2"), get_value_for(measure, "PCI/OPHONE3") ].join("-")
      @title =  get_value_for(measure, "ADMIN/RANK")
      @endowed_position = get_value_for(measure, "PCI/ENDPOS")

      #collections
      @areas_of_expertise = find_areas_of_expertise(measure)
      @education = find_education(measure)
      @publications = find_publications(measure)
      @books = find_books(measure)
      @presentations = find_presentations(measure)
      @teaching = find_teaching(measure)
      @working_papers = find_working_papers(measure)
      @articles_and_chapters = find_books_articles_chapters(measure)
      @cv_url = find_cv_url(measure)
    end



    def get_value_for(xml_doc, xpath_for)
      xml_doc.xpath("//#{xpath_for}").first.nil? ? "" : xml_doc.xpath("//#{xpath_for}").first.text.strip
    end

    def self.url_template
      "https://www.digitalmeasures.com/login/service/v4/SchemaData/INDIVIDUAL-ACTIVITIES-Business/USERNAME:%s"
    end

    def self.find_netid(netid)
      url = self.url_template % netid

      request = Typhoeus::Request.new(
        url,
        userpwd: ENV['DIGITAL_MEASURES_CREDENTIALS']
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
            log req.inspect
          end
        end

        hydra.queue(req)
      end

      hydra.run

      responses
    end


  private

    def find_cv_url(measure)
      if get_value_for(measure, "PCI/UPLOAD_CV").blank?
        ""
      else
        "https://s3.amazonaws.com/digitalmeasures.fs.mendoza.notredame/#{get_value_for(measure, "PCI/UPLOAD_CV")}"
      end
    end


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

    ######################################################
    # => INTELLCONT ITEMS

    def find_books_articles_chapters(measure)
      contypes = ["Book, Referred Article", "Book, Review", "Book, Scholarly-Contributed Chapter"]
      items = []

      measure.xpath("//INTELLCONT").each do | n |
        if contypes.include?(n.xpath("CONTYPE").first.text.strip) && (n.xpath("WEBPAGE_INCLUDE").present? && n.xpath("WEBPAGE_INCLUDE").first.text.strip == "Yes" )
          authors = []
          parts = []

          parts << make_linkable(n.xpath("TITLE"), n.xpath("WEB_ADDRESS"))

          authors = collect_authors(n.xpath("INTELLCONT_AUTH"))

          unless authors.empty?
            parts << "(with #{authors.join(", ")})"
          end

          items << parts.join(" ")

        end
      end

      return items


    end



    def find_publications(measure)
      #marked for web
      contypes = ["Journal Articles, Refereed", "Journal Articles", "Non-Refereed", "Other"]
      items = []
      measure.xpath("//INTELLCONT").each do | n |
        if contypes.include? n.xpath("CONTYPE").first.text.strip

          authors = collect_authors(n.xpath("INTELLCONT_AUTH"))

          unless authors.empty?
            with = "(with #{authors.join(", ")}),"
          else
            with = ""
          end


          link = make_linkable(n.xpath("TITLE"), n.xpath("WEB_ADDRESS") )

          #<xsl:if test="string-length(t:PAGENUM) > 0">
          if n.xpath("STATUS").first.text.strip == "Accepted"
            where_preface = "To appear in "
          else
            where_preface = ""
          end
          where_parts = []

          where_parts << "#{where_preface}<i>#{n.xpath("PUBLISHER").first.text.strip}</i>"

          unless n.xpath("VOLUME").first.text.strip.blank?
            where_parts << n.xpath("VOLUME").first.text.strip
          end

          unless n.xpath("DTY_PUB").first.text.strip.blank?
            where_parts << n.xpath("DTY_PUB").first.text.strip
          end

          where = where_parts.join(", ")

          items << ["\"#{link}\",", "#{with}", where].join(" ") + "."
        end
      end
      return items
    end

    def find_books(measure)

      contypes = ["Book, Scholarly" "Book, Textbook-New" ,"Book, Textbook-Revised"]
      items = []
      measure.xpath("//INTELLCONT").each do | n |
        if contypes.include?(n.xpath("CONTYPE").first.text.strip) && n.xpath("WEBPAGE_INCLUDE").first.text.strip == "Yes"
          parts = []
          authors = []
          special_chars = ["?", "."]
          title = "\"#{n.xpath("TITLE").first.text.strip}\""
          if special_chars.include? title.split.last
            parts << title
          else
            parts << title + ","
          end

          authors = collect_authors(n.xpath("INTELLCONT_AUTH"))

          unless authors.empty?
            parts << "(with #{authors.join(", ")}),"
          end

          parts << n.xpath("PUBLISHER").first.text.strip + ","

          parts << published_date(n)

          items << parts.join(" ")

        end
      end
      return items
    end




    def find_presentations(measure)
      #PRESENT[t:WEBPAGE_INCLUDE='Yes']) > 0">
      items = []
      measure.xpath("//PRESENT").each do | n |
        if n.xpath("WEBPAGE_INCLUDE").present? && n.xpath("WEBPAGE_INCLUDE").first.text.strip == "Yes"
          texties = []
          texties << "#{n.xpath("PRESENT_AUTH/FNAME").first.text.strip} #{n.xpath("PRESENT_AUTH/LNAME").first.text.strip}, #{n.xpath("NAME").first.text.strip}, #{n.xpath("ORG").first.text.strip}, #{n.xpath("LOCATION").first.text.strip}, \"#{n.xpath("TITLE").first.text.strip}\""
          texties << "(#{n.xpath("DTM_DATE").first.text.strip}"

          unless n.xpath("DTD_DATE").first.text.strip.blank?
            texties << "#{n.xpath("DTD_DATE").first.text.strip},"
          end

          texties << "#{n.xpath("DTY_DATE").first.text.strip})."

          items << texties.join(" ")
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


    #supporting methods

    def published_date(item)

      date_parts = []

      unless item.xpath("DTM_PUB").first.text.strip.blank?
        date_parts << item.xpath("DTM_PUB").first.text.strip

        unless item.xpath("DTD_PUB").first.text.strip.blank?
          date_parts << item.xpath("DTD_PUB").first.text.strip + ","
        end

      end

      unless item.xpath("DTY_PUB").first.text.strip.blank?
        date_parts << item.xpath("DTY_PUB").first.text.strip
      end

      return date_parts.join(" ")

    end


    def make_linkable(text_node, url_node)
      unless url_node.first.text.strip.blank? || url_node.first.text.strip == "http://"
        "<a href=\"#{url_node.first.text.strip}\">#{text_node.first.text.strip}</a>"
      else
        "#{text_node.first.text.strip}"
      end
    end

    def collect_authors(authors_xml)
      authors = []
      #puts authors_xml.count
      authors_xml.each do | a |
        unless a.xpath("FNAME").first.text.strip == @first_name && a.xpath("LNAME").first.text.strip == @last_name
          authors << "#{a.xpath("FNAME").first.text.strip} #{a.xpath("LNAME").first.text.strip}"
        end
      end

      return authors

    end


        def self.log(msg)
      msg = "[digital measures] #{msg}"
      if defined? Rails
        Rails.logger.info msg
      else
      end
        #puts msg
    end
  end







end
