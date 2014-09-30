require 'test_helper'

def fixture_xml(name)
  File.read( File.join(File.expand_path('../fixtures', __FILE__), name + '.xml') )
end

describe MendozaDigitalMeasures::Measure do
  let(:ackerman_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('cackerm1')) }
  let(:jaffleck_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('jaffleck')) }
  let(:failed_response) { Typhoeus::Response.new(code: 404, body: '')  }


  describe "with C Ackerman data" do
    before(:each) do
      subject = MendozaDigitalMeasures::Measure.new(fixture_xml('cackerm1'))
      @faculty = subject.to_hash
    end

    it 'converts the response to a hash' do
      @faculty.must_be_kind_of Hash
    end

    it 'pulls in personal information' do
      @faculty[:first_name].must_equal "Carl"
      @faculty[:last_name].must_equal "Ackermann"
      @faculty[:phone].must_equal "574-631-8407"
      @faculty[:email].must_equal "Ackermann.1@nd.edu"
      @faculty[:title].must_equal "Professional Specialist"
      @faculty[:endowed_position].must_equal "Nolan Professorship for Excellence in Undergraduate Instruction"
    end

    it "pulls in an array of expertise as area of expertise" do
      @faculty[:areas_of_expertise].must_be_kind_of Array
      @faculty[:areas_of_expertise].count.must_equal 3
      @faculty[:areas_of_expertise].first.must_equal "Mutual Funds"
      @faculty[:areas_of_expertise].last.must_equal "Personal Finance"
    end

    it "pulls in an array of education" do
      @faculty[:education].must_be_kind_of Array
      @faculty[:education].count.must_equal 2
      #puts @faculty[:education]
      @faculty[:education].first.must_equal "Ph D, University of North Carolina at Chapel Hill"
    end


    it "pulls in an array of teaching" do
      @faculty[:teaching].must_be_kind_of Array
      puts @faculty[:teaching].inspect
      #todo why does this return four but only show one on site
      #@faculty[:teaching].count.must_equal 1
      @faculty[:teaching].first.must_equal "Corporate Financial Management"
    end
  end

  describe "with Corey Angst Data" do
    before(:each) do
      subject = MendozaDigitalMeasures::Measure.new(fixture_xml('cangst'))
      @corey = subject.to_hash
    end


    it "pulls in publications" do
      @corey[:publications].must_be_kind_of Array
      @corey[:publications].count.must_equal 16
      @corey[:publications].first.must_equal '<a href="http://onlinelibrary.wiley.com/doi/10.1002/smj.2300/pdf">"The Impact of Culture on the Relationship between Governance and Opportunism in Outsourcing Relationships</a>,"(with Sean  Handley,), To appear in <i>Strategic Management Journal</i>, Forthcoming, 2015.'
    end


    it "pulls in books" do
      @corey[:books].must_be_kind_of Array
      @corey[:books].count.must_equal 2
    end

    it "presentations" do
      @corey[:presentations].must_be_kind_of Array
      @corey[:presentations].count.must_equal 29
    end



  end
end
