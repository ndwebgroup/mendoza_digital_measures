require 'test_helper'

def fixture_xml(name)
  File.read( File.join(File.expand_path('../fixtures', __FILE__), name + '.xml') )
end

describe DigitalMeasures::Index do
  let(:subject){DigitalMeasures::Index}
  let(:index_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('index')) }

  describe "Typhoeus Requests" do
    it 'creates a typhoeus request for a list of netids' do
      netids = subject.all
      netids.must_be_kind_of Array
      netids.count.wont_equal 0
      netids.first.must_equal "cackerm1"
    end
  end

end
