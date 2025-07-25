# spec/integration/orders_api_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Orders API Integration', type: :request do
  let(:customer_id) { 1 }
  let(:params) do
    { 
      order: {
        customer_id: customer_id,
        order_items_attributes: [
          {
            product_name: 'Super Producto', 
            quantity: 50, 
            price: 25.0
          },
          {
            product_name: 'Super Producto 2', 
            quantity: 200, 
            price: 20.0
          }
        ]
      }   
    }
  end

  let(:mock_publisher) { instance_double(Broker::RabbitmqPublisher, publish_created: true) }

  before do
    stub_request(:get, "http://customer_service:3000/customers/#{customer_id}")
      .to_return(status: 200, body: { id: customer_id, name: 'Test' }.to_json, headers: { 'Content-Type' => 'application/json' })

    allow(Broker::RabbitmqPublisher).to receive(:new).and_return(mock_publisher)
  end

  it 'creates a new order and triggers event publishing' do
    post '/orders', params: params

    expect(response).to have_http_status(:created)

    body = JSON.parse(response.body)
    expect(body['customer_id']).to eq(customer_id)

    expect(mock_publisher).to have_received(:publish_created).once
  end
end
