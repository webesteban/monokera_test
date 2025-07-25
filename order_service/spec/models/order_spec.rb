require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:customer_id) }

    it 'is invalid with an unknown status' do
      expect {
        described_class.new(status: 'invalid')
      }.to raise_error(ArgumentError, "'invalid' is not a valid status")
    end
  end


  describe 'enums' do
    it 'defines correct statuses' do
      expect(described_class.statuses.keys).to match_array(%w[pending confirmed shipped cancelled])
    end

    it 'adds prefixed _status? methods' do
      order = build(:order, status: 'pending')
      expect(order.status_pending?).to be true
    end
  end
end
