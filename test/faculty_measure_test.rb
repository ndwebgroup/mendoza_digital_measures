require 'test_helper'

def fixture_xml(name)
  File.read( File.join(File.expand_path('../fixtures', __FILE__), name + '.xml') )
end

describe MendozaDigitalMeasures::Measure do
  let(:ackerman_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('cackerm1')) }
  let(:jaffleck_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('jaffleck')) }
  let(:failed_response) { Typhoeus::Response.new(code: 404, body: '')  }

  describe "class method finders" do
    let(:subject){MendozaDigitalMeasures::Measure}

    it 'creates multiple requests for multiple users' do
      ackerman, affleck = subject.find_netids 'cackerm1', 'jaffleck'
      ackerman.must_be_kind_of MendozaDigitalMeasures::Measure
      affleck.must_be_kind_of MendozaDigitalMeasures::Measure
    end


    it 'returns the successful requests and leaves off  failed requests' do
      ackerman, affleck, failure = subject.find_netids 'cackerm1', 'jaffleck', 'ahipshea'
      ackerman.wont_be :nil?
      affleck.wont_be :nil?
      failure.must_be :nil?
    end

  end



  describe "with C Ackerman data" do
    before(:each) do
      @faculty = MendozaDigitalMeasures::Measure.new(fixture_xml('cackerm1'))
    end

    it 'converts the response to a Measure Object' do
      @faculty.must_be_kind_of MendozaDigitalMeasures::Measure
      #puts @faculty.inspect
    end

    it 'pulls in personal information' do
      @faculty.first_name.must_be_kind_of String
      @faculty.first_name.must_equal "Carl"
      @faculty.last_name.must_equal "Ackermann"
      @faculty.phone.must_equal "574-631-8407"
      @faculty.email.must_equal "Ackermann.1@nd.edu"
      @faculty.title.must_equal "Professional Specialist"
      @faculty.endowed_position.must_equal "Nolan Professorship for Excellence in Undergraduate Instruction"
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


    it "pulls in an array of teaching" do
      @faculty.teaching.must_be_kind_of Array

      #todo why does this return four but only show one on site
      #@faculty.teaching].count.must_equal 1
      @faculty.teaching.first.must_equal "Corporate Financial Management"
    end

  end

  describe "with Corey Angst Data" do
    before(:each) do
      @corey = MendozaDigitalMeasures::Measure.new(fixture_xml('cangst'))
    end


    it "pulls in publications" do
      @corey.publications.must_be_kind_of Array
      @corey.publications.count.must_equal 16
    end

    it "formats publications in a very specific way" do
      #add "(with Sean  Handley,), after title link
      @corey.publications.first.must_equal '<a href="http://onlinelibrary.wiley.com/doi/10.1002/smj.2300/pdf">"The Impact of Culture on the Relationship between Governance and Opportunism in Outsourcing Relationships"</a>, To appear in <i>Strategic Management Journal</i>, Forthcoming, 2015.'
    end

    it "pulls in books" do
      @corey.books.must_be_kind_of Array
      @corey.books.count.must_equal 2
    end

    it "presentations" do
      @corey.presentations.must_be_kind_of Array

      #@corey.presentations.each{ | p | puts ">>> #{p}"}
      #@corey.presentations.count.must_equal 29
    end

    it "formats presentations in a very specific way" do
      @corey.presentations.must_be_kind_of Array
      @corey.presentations.first.must_equal "Corey Angst, Hesburgh Lecture Series, ND Club o f Greater Seattle, Seattle, WA, \"Who’s Watching Me?  What \“Big Data\” Means to All of Us\" (November 12, 2014)."
    end

  end

end
