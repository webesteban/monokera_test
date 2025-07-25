require 'swagger_helper'

RSpec.describe 'Orders API', type: :request do
  path '/orders' do
    post 'Create an order' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          order: {
            type: :object,
            properties: {
              customer_id: { type: :integer },
              product_name: { type: :string },
              quantity: { type: :integer },
              price: { type: :number },
              status: { type: :string }
            },
            required: %w[customer_id product_name quantity price status]
          }
        },
        required: ['order']
      }

      response '201', 'order created' do
        let(:existing_customer_id) { '1'
         }

        before do
          allow_any_instance_of(Http::CustomerService).to receive(:fetch_customer)
            .with(existing_customer_id)
            .and_return({ id: existing_customer_id, name: 'Test User' })
        end

        let(:order) do
          {
            order: {
              customer_id: existing_customer_id,
              product_name: 'Product',
              quantity: 2,
              price: 19.99,
              status: 'pending'
            }
          }
        end

        run_test!
      end

      response '422', 'customer not found' do
        let(:nonexistent_customer_id) { 9999 }

        before do
          allow_any_instance_of(Http::CustomerService).to receive(:fetch_customer)
            .with(nonexistent_customer_id)
            .and_return(nil)
        end

        let(:order) do
          {
            order: {
              customer_id: nonexistent_customer_id,
              product_name: 'Product',
              quantity: 2,
              price: 19.99,
              status: 'pending'
            }
          }
        end

        run_test! do |response|
          expect(response.body).to include('Customer not found')
        end
      end
    end

    get 'List orders by customer' do
      tags 'Orders'
      produces 'application/json'
      parameter name: :customer_id, in: :query, type: :integer

      response '200', 'orders found' do
        let(:existing_customer_id) { '1' }

        before do
          allow_any_instance_of(Http::CustomerService).to receive(:fetch_customer)
            .with(existing_customer_id)
            .and_return({ id: existing_customer_id, name: 'Test User' })

          Order.create!(
            customer_id: existing_customer_id,
            product_name: 'Test Product',
            quantity: 1,
            price: 10.0,
            status: 'confirmed'
          )
        end

        let(:customer_id) { existing_customer_id }

        run_test!
      end

      response '422', 'customer not found' do
        let(:nonexistent_customer_id) { '9999' }

        before do
          allow_any_instance_of(Http::CustomerService).to receive(:fetch_customer)
            .with(nonexistent_customer_id)
            .and_return(nil)
        end

        let(:customer_id) { nonexistent_customer_id }

        run_test! do |response|
          expect(response.body).to include('Customer not found')
        end
      end
    end
  end
end
