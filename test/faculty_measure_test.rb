require 'test_helper'

def fixture_xml(name)
  File.read( File.join(File.expand_path('../fixtures', __FILE__), name + '.xml') )
end

describe MendozaDigitalMeasures::Measure do
  let(:ackerman_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('cackerm1')) }
  let(:jaffleck_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('jaffleck')) }
  let(:failed_response) { Typhoeus::Response.new(code: 404, body: '')  }

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
    @faculty[:endowed_position].must_equal "Nolan Professorship for Excellence in Undergraduate Instruction"
  end

  it "pulls in an array of expertise as area of expertise" do
    @faculty[:areas_of_expertise].must_be_kind_of Array
    @faculty[:areas_of_expertise].count.must_equal 3
    @faculty[:areas_of_expertise].first.must_equal "Mutual Funds"
    @faculty[:areas_of_expertise].last.must_equal "Personal Finance"
  end

end
