require 'rails_helper'

RSpec.describe Orders::List, type: :service do
  describe '#call' do
    let(:customer_id) { 1 }

    subject(:service_call) { described_class.new(customer_id: customer_id).call }

    context 'when customer exists' do
      let!(:order1) { create(:order, customer_id: customer_id, product_name: 'Libro') }
      let!(:order2) { create(:order, customer_id: customer_id, product_name: 'Café') }

      before do
        allow_any_instance_of(Http::CustomerService)
          .to receive(:fetch_customer)
          .with(customer_id)
          .and_return({ id: customer_id, name: 'Cliente válido', orders_count: 2 })
      end

      it 'returns the list of orders for the customer' do
        result = service_call

        expect(result).to match_array([order1, order2])
      end
    end

    context 'when customer does not exist' do
      before do
        allow_any_instance_of(Http::CustomerService)
          .to receive(:fetch_customer)
          .with(customer_id)
          .and_return(nil)
      end

      it 'raises CustomerNotFoundError' do
        expect { service_call }.to raise_error(Orders::List::CustomerNotFoundError)
      end
    end
  end
end
