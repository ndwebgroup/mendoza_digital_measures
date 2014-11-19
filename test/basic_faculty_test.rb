require 'test_helper'

def fixture_xml(name)
  File.read( File.join(File.expand_path('../fixtures', __FILE__), name + '.xml') )
end

describe DigitalMeasures::Faculty do
  let(:dm_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('sveramun')) }
  let(:subject){DigitalMeasures::Faculty}

  describe "with faculty data" do

    before(:each) do
      @faculty = DigitalMeasures::Faculty.new(fixture_xml('sveramun'))
    end

    it 'converts the response to a Measure Object' do
      @faculty.must_be_kind_of DigitalMeasures::Faculty
    end

    it 'pulls in personal information' do
      @faculty.first_name.must_be_kind_of String
      @faculty.last_name.must_be_kind_of String
      @faculty.middle_name.must_be_kind_of String
      @faculty.phone.must_be_kind_of String
      @faculty.email.must_be_kind_of String
      @faculty.title.must_be_kind_of String
      @faculty.prefix.must_be_kind_of String
      @faculty.suffix.must_be_kind_of String
      @faculty.endowed_position.must_be_kind_of String
    end

    it "pulls in an array of expertise as area of expertise" do
      @faculty.areas_of_expertise.must_be_kind_of Array
    end

    it "pulls in an array of education" do
      @faculty.education.must_be_kind_of Array
    end

    it "returns 'degother' if deg eq 'Other' " do
      @faculty.education.must_be_kind_of Array
    end

    it "pulls in an array of teaching" do
      @faculty.teaching.must_be_kind_of Array
    end

    it "pulls in publications" do
      @faculty.publications.must_be_kind_of Array
    end

    it "pulls in books" do
      @faculty.books.must_be_kind_of Array
    end

    it "presentations" do
      @faculty.presentations.must_be_kind_of Array
    end

    it "returns working papers" do
      @faculty.working_papers.must_be_kind_of Array
    end

  end

end
