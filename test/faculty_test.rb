require 'test_helper'

def fixture_xml(name)
  File.read( File.join(File.expand_path('../fixtures', __FILE__), name + '.xml') )
end

describe MendozaDigitalMeasures::Faculty do
  subject { MendozaDigitalMeasures::Faculty }
  let(:ackerman_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('cackerm1')) }
  let(:jaffleck_response) { Typhoeus::Response.new(code: 200, body: fixture_xml('jaffleck')) }
  let(:failed_response) { Typhoeus::Response.new(code: 404, body: '')  }

  it 'creates a typhoeus request for a netid' do
    request = subject.request_for_netid('ahipshea')
    request.must_be_kind_of Typhoeus::Request
    request.base_url.must_match(/ahipshea/)
    request.base_url.must_match(/INDIVIDUAL-ACTIVITIES/)
  end

  describe 'with stubbed requests' do
    before(:each) do
      Typhoeus.stub(/cackerm1/).and_return(ackerman_response)
      Typhoeus.stub(/jaffleck/).and_return(jaffleck_response)
      Typhoeus.stub(/.*/).and_return(failed_response)
    end

    it 'creates multiple requests for multiple users' do
      ackerman, affleck = subject.find_multiple_netids 'cackerm1', 'jaffleck'

      ackerman.response.wont_be :blank?
      affleck.response.wont_be :blank?
    end

    it 'returns the successful requests and nil for the failed requests' do
      ackerman, affleck, failure = subject.find_multiple_netids 'cackerm1', 'jaffleck', 'ahipshea'
      ackerman.response.wont_be :blank?
      affleck.response.wont_be :blank?
      failure.response.must_be :blank?
    end
  end

  describe 'Measure Objects with stubbed requests' do
    before(:each) do
      Typhoeus.stub(/cackerm1/).and_return(ackerman_response)
      Typhoeus.stub(/jaffleck/).and_return(jaffleck_response)
      Typhoeus.stub(/.*/).and_return(failed_response)
    end


=begin
    it 'returns an array of Measure objects' do
      measures = subject.get_measures_for 'cackerm1', 'jaffleck'
      measures.must_be_kind_of Array

      measures.count.must_equal 2
      measures.first.must_be_kink_of MendozaDigitalMeasures::Measure.new
    end
=end
  end
end
