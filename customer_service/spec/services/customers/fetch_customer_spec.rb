require 'rails_helper'

RSpec.describe Customers::FetchCustomer do
  describe '#call' do
    let!(:customer) { create(:customer) }

    it 'returns the customer when found' do
      result = described_class.new(customer.id).call
      expect(result).to eq(customer)
    end

    it 'returns nil when customer not found' do
      result = described_class.new(-1).call
      expect(result).to be_nil
    end
  end
end
