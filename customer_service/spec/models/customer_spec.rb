require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }


    it 'raises error with invalid enum value' do
      expect { build(:customer, status: 'invalid') }.to raise_error(ArgumentError, /invalid/)
    end

    it 'is valid with allowed statuses' do

      expect(build(:customer, status: 'active')).to be_valid
      expect(build(:customer, status: 'inactive')).to be_valid
    end
  end

  describe 'enums' do
    it 'defines correct statuses' do
      expect(described_class.statuses.keys).to match_array(%w[active inactive suspended])
    end

    it 'adds _status? methods' do
      customer = build(:customer, status: 'active')
      expect(customer.active_status?).to be true
    end
  end
end