require 'rails_helper'

RSpec.describe Orders::Create, type: :service do
  describe '#call' do
    let(:params) do
      {
        product_name: 'Super Producto',
        quantity: 200,
        customer_id: customer_id,
        price: 20.0
      }
    end

    subject(:service_call) { described_class.new(params).call }

    context 'when customer exists' do
      let(:customer_id) { 1 }

      before do
        allow_any_instance_of(Http::CustomerService)
          .to receive(:fetch_customer)
          .with(customer_id)
          .and_return({ id: customer_id, name: 'Juan', orders_count: 0 })
      end

      it 'creates an order' do
        expect { service_call }.to change(Order, :count).by(1)
      end

      it 'returns the created order' do
        result = service_call
        expect(result).to be_a(Order)
        expect(result.product_name).to eq('Super Producto')
      end

      it 'publishes an order.created event' do
        expect_any_instance_of(Broker::RabbitmqPublisher)
          .to receive(:publish_created)
          .with(instance_of(Order))

        service_call
      end
    end

    context 'when customer does not exist' do
      let(:customer_id) { 999 }

      before do
        allow_any_instance_of(Http::CustomerService)
          .to receive(:fetch_customer)
          .with(customer_id)
          .and_return(nil)
      end

      it 'raises CustomerNotFoundError' do
        expect { service_call }.to raise_error(Orders::Create::CustomerNotFoundError)
      end
    end

    context 'when parameters are invalid' do
      let(:customer_id) { 1 }

      before do
        allow_any_instance_of(Http::CustomerService)
          .to receive(:fetch_customer)
          .with(customer_id)
          .and_return({ id: customer_id, name: 'Juan', orders_count: 0 })
      end

      let(:params) { { product_name: nil, quantity: nil, price: nil,  customer_id: customer_id } }

      it 'raises ActiveRecord::RecordInvalid' do
        expect { service_call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
