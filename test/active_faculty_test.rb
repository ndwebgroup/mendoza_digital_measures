require 'test_helper'

def fixture_xml(name)
  File.read( File.join(File.expand_path('../fixtures', __FILE__), name + '.xml.erb') )
end

describe DigitalMeasures::Faculty do
  let(:jarp_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('jarp')) }
  let(:failed_response) { Typhoeus::Response.new(code: 404, body: '')  }
  let(:subject){DigitalMeasures::Faculty}


  describe "Typhoeus Requests" do
    it 'creates a typhoeus request for a netid' do
      request = subject.find_netid('ahipshea')
      request.must_be_kind_of Typhoeus::Request
      request.base_url.must_match(/ahipshea/)
      request.base_url.must_match(/INDIVIDUAL-ACTIVITIES/)
    end
  end

  describe "CLASS method finders" do

    it 'creates multiple requests for multiple users' do
      ackerman, affleck = subject.find_netids ['cackerm1', 'jaffleck']
      ackerman.must_be_kind_of DigitalMeasures::Faculty
      affleck.must_be_kind_of DigitalMeasures::Faculty
    end


    it 'returns the successful requests and leaves off  failed requests' do
      ackerman, affleck, failure = subject.find_netids ['cackerm1', 'jaffleck', 'ahipshea']
      ackerman.wont_be :nil?
      affleck.wont_be :nil?
      failure.must_be :nil?
    end

    it "returns an array of dm members" do
      members = subject.find_netids ['cackerm1', 'jaffleck', 'ahipshea']
      members.must_be_kind_of Array
      members.count.must_equal 2
    end
  end

#
#
  describe "DigitalMeasures Data" do
    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('jarp'))
    end

    it 'converts the response to a Measure Object' do
      @faculty.must_be_kind_of DigitalMeasures::Faculty
      #puts @faculty.inspect
    end

    it "returns the userid" do
      @faculty.user_id.must_equal 9000042
    end


    it 'pulls in personal information' do
      @faculty.first_name.must_be_kind_of String
      @faculty.first_name.must_equal "Hacksaw"
      @faculty.last_name.must_equal "Arp"
      @faculty.middle_name.must_equal "E"
      @faculty.phone.must_equal "574-631-1480"
      @faculty.email.must_equal "hacksaw.arp@nd.edu"
      @faculty.title.must_equal "Prince Developer"
      @faculty.prefix.must_equal "King"
      @faculty.suffix.must_equal "Esq."
      @faculty.endowed_position.must_equal "Programmer of the Gods"
    end

    it "pulls in netid" do
      @faculty.netid.must_equal "hacksaw"
    end

    it "pulls in an array of expertise as area of expertise" do
      @faculty.areas_of_expertise.must_be_kind_of Array
      @faculty.areas_of_expertise.count.must_equal 2
      @faculty.areas_of_expertise.first.must_equal "Ruby"
      @faculty.areas_of_expertise.last.must_equal "ColdFusion"
    end

    it "pulls in an array of education" do
      @faculty.education.must_be_kind_of Array
      @faculty.education.count.must_equal 2
      #puts @faculty.education]
      @faculty.education.first.must_equal "Ph D, Wheaton College"
    end

    it "returns 'degother' if deg eq 'Other' " do
        @faculty.education.last.must_equal "CSS, Devrie Tech"
    end

    it "pulls in an array of teaching" do
      @faculty.teaching.must_be_kind_of Array
      @faculty.teaching.count.must_equal 2
      @faculty.teaching.first.must_equal "This Years Amazing Class"
      @faculty.teaching.last.must_equal "Last Years Amazing Class"
    end

    it "returns an empty url because there is no CV" do
      @faculty.cv_url.must_equal ""
    end

    it "returns a url to CV" do
      #@faculty.cv_url.must_equal ""
    end
  #
    it "pulls in publications" do
      @faculty.publications.must_be_kind_of Array
      @faculty.publications.count.must_equal 3
    end

    it "formats publications in a very specific way" do
      #add "(with Sean  Handley,), after title link
      #puts @faculty.publications[1].inspect
      @faculty.publications[0].must_equal '"<a href="http://tinyurl.com/2015SMJ">Published Publication FTW - co author with a dude and a link</a>", (with Sean Handley), To appear in <i>Strategic Management Journal</i>, 36, 2015.'
      @faculty.publications[1].must_equal '"A Submitted Publication with Nada for links but several co authors", (with Kaitlin Wowak, Sean Handley, Ken Kelley), <i>Production and Operations Management</i>.'
    end

    # it "pulls in book chapters and articles" do
    #   @corey.articles_and_chapters.must_be_kind_of Array
    #   @corey.articles_and_chapters.count.must_equal 2
    # end
    #
    it "presentations" do
      @faculty.presentations.must_be_kind_of Array
      @faculty.presentations.count.must_equal 1
    end

    it "formats presentations in a very specific way" do
      @faculty.presentations.first.must_equal "Hesburgh Lecture Series, \"Who’s Watching Me?  What \“Big Data\” Means to All of Us\" (November 12, 2014)."
    end


      it "returns books" do
        @faculty.books.must_be_kind_of Array
        @faculty.books.count.must_equal 3
      end

      it "returns books with link if present and no authors cause the only one is the faculty member" do
        @faculty.books[0].must_equal '"<a href="http://EngagingEthicalMillennials.nd.edu">A Book with a link to a webpage</a>", Business Expert Press, 2015'
      end

      it "returns books with other authors if present" do
        @faculty.books[1].must_equal '"This book does not have a link to anywhere", Hogwart\'s Printers, 2015'
      end

      it "returns books with other authors" do
        @faculty.books[2].must_equal '"I wrote this book with my friends", (with Maria Cecilia Coutinho de Arruda, Cheng Wang), Hogwart\'s Printers, 2015'
      end




  #
  #   it "returns working papers" do
  #     @corey.working_papers.must_be_kind_of Array
  #     puts "\n>>> working papers :: #{@corey.working_papers.count} :: #{@corey.working_papers.inspect}"
  #     @corey.working_papers.count.must_equal 2
  #   end
  #
  #   it "formats papers in a particular way" do
  #     @corey.working_papers.first.must_equal "Ritu Agarwal, \"Gestational Use and Its Effect on Early System Use and Usage Growth Trajectories: A Longitudinal Analysis Investigating Change in Technology Use Over Time.\""
  #     @corey.working_papers.last.must_equal "Massimo Magni, \"<a href=\"http://ssrn.com/abstract=1273151\">Users’ Intention to Explore: A creativity-based perspective</a>.\""
  #   end
  #
  # end
  #
  # describe "with jmcmanus Data" do
  #   before(:each) do
  #     @faculty = DigitalMeasures::Faculty.new(fixture_xml('jmcmanus'))
  #   end
  #
  #   # it "returns articles chapters" do
  #   #   @faculty.articles_and_chapters.must_be_kind_of Array
  #   #   @faculty.articles_and_chapters.count.must_equal 2
  #   # end
  #

  # end
#
#
#   describe "with jorourke Data" do
#     before(:each) do
#       @faculty = DigitalMeasures::Faculty.new(fixture_xml('jorourke'))
#     end
#
#     it "returns a formated url to cv with netid" do
#       @faculty.cv_url.must_equal "http://digitalmeasures.fs.mendoza.notredame.s3-website-us-east-1.amazonaws.com/jorourke/pci/jorourke.pdf"
#     end
#
#     it "returns articles, book reviews and book chapters" do
#       @faculty.articles_and_chapters.must_be_kind_of Array
#       #@faculty.articles_and_chapters.count.must_equal 13
#     end
#

#
#     it "returns publications" do
#       @faculty.publications.must_be_kind_of Array
#       #@faculty.publications.count.must_equal 21
#     end
#
#
#   end
#
# describe "with reasley Data" do
#
#     before(:each) do
#       @faculty = DigitalMeasures::Faculty.new(fixture_xml('reasley'))
#     end
#
#     it "returns teaching from the last two years" do
#       @faculty.teaching.count.must_equal 0
#     end
#
#     it "returns a publication with collab authors" do
#       @faculty.publications.first.must_equal "\"Bidding Patterns, Experience, and Avoiding the Winner's Curse in Online Auctions\", (with Charles Wood, Sharad Barkataki), <i>JMIS</i>, 27, 2011."
#     end
#   end
#
#   describe "with g bern Data" do
#     before(:each) do
#       @faculty = DigitalMeasures::Faculty.new(fixture_xml('gbern'))
#     end
#
#     it "returns book " do
#       @faculty.books.count.must_equal 1
#     end
#   end
#
#   describe "with o williams Data" do
#     before(:each) do
#       @faculty = DigitalMeasures::Faculty.new(fixture_xml('owilliam'))
#     end
#

#     it "first publication should not have a collab author" do
#       @faculty.publications.first.must_equal "\"The United Nations Global Compact: What Did It Promise?\",  <i>Journal of Business Ethics</i>, 25, 2014."
#     end
#   end
#
#   describe "with dspiess data" do
#     before(:each) do
#       @faculty = DigitalMeasures::Faculty.new(fixture_xml('dspiess'))
#     end
#
#     it "returns preffered name instead of first name if present" do
#       @faculty.last_name.must_equal "Spiess"
#       @faculty.first_name.must_equal "Katherine"
#     end
#   end
#
#   describe "with metta world peace" do
#     before(:each) do
#       @faculty = DigitalMeasures::Faculty.new(fixture_xml('pname'))
#     end
#
#     it "returns preffered name instead of first name if present" do
#       @faculty.first_name.must_equal "Metta World Peace"
#     end
#   end
#
#   describe "with blevey" do
#     before(:each) do
#       @faculty = DigitalMeasures::Faculty.new(fixture_xml('blevey'))
#     end
#
#     it "returns Journal Articles, Non-Refereed as a publication" do
#       @faculty.publications.last.must_match "Tortious Government Conduct and the Government Contract: Tort, Breach of Contract or Both?"
#     end
#   end
#
#   describe "with hguo" do
#     before(:each) do
#       @faculty = DigitalMeasures::Faculty.new(fixture_xml('hguo'))
#     end
#
#     it "pulls in only publications that are marked for the web" do
#       @faculty.publications.count.must_equal 14
#     end
#   end
  end
end
