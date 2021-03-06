require 'test_helper'

def fixture_xml(name)
  File.read( File.join(File.expand_path('../fixtures', __FILE__), name + '.xml') )
end

describe DigitalMeasures::Faculty do
  let(:ackerman_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('cackerm1')) }
  let(:jaffleck_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('jaffleck')) }
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



  describe "with C Ackerman data" do
    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('cackerm1'))
    end

    it 'converts the response to a Measure Object' do
      @faculty.must_be_kind_of DigitalMeasures::Faculty
      #puts @faculty.inspect
    end

    it 'pulls in personal information' do
      @faculty.first_name.must_be_kind_of String
      @faculty.first_name.must_equal "Carl"
      @faculty.last_name.must_equal "Ackermann"
      @faculty.middle_name.must_equal "Alfred"
      @faculty.phone.must_equal "574-631-8407"
      @faculty.email.must_equal "Ackermann.1@nd.edu"
      @faculty.title.must_equal "Professional Specialist"
      @faculty.prefix.must_equal "Tester"
      @faculty.suffix.must_equal "Jr."
      @faculty.endowed_position.must_equal "Nolan Professorship for Excellence in Undergraduate Instruction"
    end

    it "pulls in netid" do
      @faculty.netid.must_equal "cackerm1"
    end

    it "pulls in an array of expertise as area of expertise" do
      @faculty.areas_of_expertise.must_be_kind_of Array
      @faculty.areas_of_expertise.count.must_equal 3
      @faculty.areas_of_expertise.first.must_equal "Mutual Funds"
      @faculty.areas_of_expertise.last.must_equal "Personal Finance"
    end

    it "pulls in an array of education" do
      @faculty.education.must_be_kind_of Array
      @faculty.education.count.must_equal 2
      #puts @faculty.education]
      @faculty.education.first.must_equal "Ph D, University of North Carolina at Chapel Hill"
    end

    it "returns 'degother' if deg eq 'Other' " do
      @faculty.education.last.must_equal "PH Test, Amherst College"
    end

    it "pulls in an array of teaching" do
      @faculty.teaching.must_be_kind_of Array
      @faculty.teaching.first.must_equal "Corporate Financial Management"
    end


    it "excludes teaching records older than 3 years" do
      #pending "needs test"
    end

  end

  describe "with Corey Angst Data" do
    before(:each) do
      @corey = DigitalMeasures::Faculty.new(fixture_xml('cangst'))
    end

    it "returns an enpty url because there is no CV" do
      @corey.cv_url.must_equal ""
    end

    it "pulls in publications" do
      @corey.publications.must_be_kind_of Array
      #@corey.publications.count.must_equal 16
    end

    it "returns teaching from the last two years" do
      @corey.teaching.count.must_equal 6
    end
    it "skips publications that are not marked for web" do

    end

    it "formats publications in a very specific way" do
      #add "(with Sean  Handley,), after title link
      @corey.publications.first.must_equal '"<a href="http://onlinelibrary.wiley.com/doi/10.1002/smj.2300/pdf">The Impact of Culture on the Relationship between Governance and Opportunism in Outsourcing Relationships</a>", (with Sean Handley), To appear in <i>Strategic Management Journal</i>, Forthcoming, 2015.'
    end

    it "pulls in books" do
      @corey.books.must_be_kind_of Array
      @corey.books.count.must_equal 0
    end

    it "pulls in book chapters and articles" do
      @corey.articles_and_chapters.must_be_kind_of Array
      @corey.articles_and_chapters.count.must_equal 2
    end

    it "presentations" do
      @corey.presentations.must_be_kind_of Array
      @corey.presentations.count.must_equal 29
    end

    it "formats presentations in a very specific way" do
      @corey.presentations.must_be_kind_of Array
      @corey.presentations.first.must_equal "Corey Angst, Hesburgh Lecture Series, ND Club o f Greater Seattle, Seattle, WA, \"Who’s Watching Me?  What \“Big Data\” Means to All of Us\" (November 12, 2014)."
      @corey.presentations.last.must_equal "Corey Angst, Toward an Electronic Patient Record (TEPR), , Ft. Lauderdale, FL, \"Patients' Perceived Value of Using a Personal Health Record\" (May 2004)."
    end

    it "returns working papers" do
      @corey.working_papers.must_be_kind_of Array
      @corey.working_papers.count.must_equal 2
    end

    it "formats papers in a particular way" do
      @corey.working_papers.first.must_equal "Ritu Agarwal, \"Gestational Use and Its Effect on Early System Use and Usage Growth Trajectories: A Longitudinal Analysis Investigating Change in Technology Use Over Time.\""
      @corey.working_papers.last.must_equal "Massimo Magni, \"<a href=\"http://ssrn.com/abstract=1273151\">Users’ Intention to Explore: A creativity-based perspective</a>.\""
    end

  end

  describe "with jmcmanus Data" do
    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('jmcmanus'))
    end

    it "returns articles chapters" do
      @faculty.articles_and_chapters.must_be_kind_of Array
      @faculty.articles_and_chapters.count.must_equal 2
    end

    it "returns books" do
      @faculty.books.must_be_kind_of Array
      @faculty.books.count.must_equal 1
    end

    it "returns books with link if present" do
      @faculty.books.first.must_equal '"<a href="http://EngagingEthicalMillennials.nd.edu">Engaging Millennials for Ethical Leadership: What Works for Young Professionals and Their Managers</a>", Business Expert Press; http://EngagingEthicalMillennials.nd.edu, 2015'
    end

  end


  describe "with jorourke Data" do
    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('jorourke'))
    end

    it "returns a formated url to cv with netid" do
      @faculty.cv_url.must_equal "http://digitalmeasures.fs.mendoza.notredame.s3-website-us-east-1.amazonaws.com/jorourke/pci/jorourke.pdf"
    end

    it "returns articles, book reviews and book chapters" do
      @faculty.articles_and_chapters.must_be_kind_of Array
      #@faculty.articles_and_chapters.count.must_equal 13
    end

    it "returns books" do
      @faculty.books.must_be_kind_of Array
      #@faculty.books.count.must_equal 13
    end

    it "returns books without link if no web address is present" do
      @faculty.books.first.must_equal '"Management Communication: A Case-Analysis Approach, 5/e", Prentice Hall, 2013'
    end

    it "returns publications" do
      @faculty.publications.must_be_kind_of Array
      #@faculty.publications.count.must_equal 21
    end


  end

describe "with reasley Data" do

    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('reasley'))
    end

    it "returns teaching from the last two years" do
      @faculty.teaching.count.must_equal 0
    end

    it "returns a publication with collab authors" do
      @faculty.publications.first.must_equal "\"Bidding Patterns, Experience, and Avoiding the Winner's Curse in Online Auctions\", (with Charles Wood, Sharad Barkataki), <i>JMIS</i>, 27, 2011."
    end
  end

  describe "with g bern Data" do
    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('gbern'))
    end

    it "returns book " do
      @faculty.books.count.must_equal 1
    end
  end

  describe "with o williams Data" do
    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('owilliam'))
    end

    it "returns the userid" do
      @faculty.user_id.must_equal 117578
    end

    it "first publication should not have a collab author" do
      @faculty.publications.first.must_equal "\"The United Nations Global Compact: What Did It Promise?\",  <i>Journal of Business Ethics</i>, 25, 2014."
    end
  end

  describe "with dspiess data" do
    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('dspiess'))
    end

    it "returns preffered name instead of first name if present" do
      @faculty.last_name.must_equal "Spiess"
      @faculty.first_name.must_equal "Katherine"
    end
  end

  describe "with metta world peace" do
    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('pname'))
    end

    it "returns preffered name instead of first name if present" do
      @faculty.first_name.must_equal "Metta World Peace"
    end
  end

  describe "with blevey" do
    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('blevey'))
    end

    it "returns Journal Articles, Non-Refereed as a publication" do
      @faculty.publications.last.must_match "Tortious Government Conduct and the Government Contract: Tort, Breach of Contract or Both?"
    end
  end

  describe "with hguo" do
    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('hguo'))
    end

    it "pulls in only publications that are marked for the web" do
      @faculty.publications.count.must_equal 14
    end
  end

end
