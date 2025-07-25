require 'rails_helper'

RSpec.describe Customers::FetchAll do
  describe '#call' do
    before { create_list(:customer, 5) }

    it 'returns paginated customers' do
      result = described_class.new.call
      expect(result.count).to eq(5)
      expect(result).to all(be_a(Customer))
    end
  end
end
