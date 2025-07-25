require 'rails_helper'

RSpec.describe Http::CustomerService, type: :adapter do
    
  let(:service) { described_class.new }
  let(:base_url) { 'http://fake-customer-service' }
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('CUSTOMER_SERVICE_URL').and_return("http://example.com")
  end

  before { allow(ENV).to receive(:[]).with('CUSTOMER_SERVICE_URL').and_return(base_url) }

  describe '#fetch_customer' do
    let(:customer_id) { 1 }
    let(:url) { "#{base_url}/customers/#{customer_id}" }

    it 'returns parsed response when 200' do
      stub_request(:get, url)
        .to_return(status: 200, body: { id: customer_id, name: 'Test' }.to_json)

      result = service.fetch_customer(customer_id)
      expect(result).to include('id' => customer_id)
    end

    it 'returns nil for 404' do
      stub_request(:get, url).to_return(status: 404)
      expect(service.fetch_customer(customer_id)).to be_nil
    end

    it 'returns nil on Faraday error' do
      stub_request(:get, url).to_timeout
      expect(service.fetch_customer(customer_id)).to be_nil
    end
  end
end
