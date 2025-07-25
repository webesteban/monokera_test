require 'rails_helper'

RSpec.describe Orders::HandleCreated do
  describe '#call' do
    let(:data) { { customer_id: customer.id } }

    context 'when customer exists' do
      let!(:customer) { create(:customer, orders_count: 1) }

      it 'increments the orders_count' do
        expect {
          described_class.new(data).call
        }.to change { customer.reload.orders_count }.by(1)
      end
    end

    context 'when customer does not exist' do
      let(:customer) { double(id: 9999) }

      it 'does nothing' do
        expect(Customer).to receive(:find_by).with(id: 9999).and_return(nil)
        expect {
          described_class.new(customer_id: 9999).call
        }.not_to raise_error
      end
    end
  end
end
