# spec/integration/customers_spec.rb

require 'swagger_helper'

RSpec.describe 'Customers API', type: :request, integration: true do
  path '/customers' do
    get 'Retrieves all customers' do
      tags 'Customers'
      produces 'application/json'

      response 200, 'successful' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   address: { type: :string },
                   orders_count: { type: :integer },
                   email: { type: :string },
                   phone_number: { type: :string },
                   status: { type: :string },
                   registered_at: { type: :string, format: 'date-time' }
                 },
               }

        run_test!
      end
    end
  end

  path '/customers/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true, description: 'customer id'

    get 'Retrieves a customer' do
      tags 'Customers'
      produces 'application/json'

      response 200, 'customer found' do
        let(:id) { Customer.create!(name: 'X', address: 'Y', orders_count: 0, status: 'active', registered_at: Time.current).id }
        run_test!
      end

      response 404, 'customer not found' do
        let(:id) { 99999 }
        run_test!
      end
    end
  end
end
