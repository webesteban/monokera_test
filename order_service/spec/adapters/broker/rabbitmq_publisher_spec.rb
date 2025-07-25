require 'rails_helper'

RSpec.describe Broker::RabbitmqPublisher, type: :adapter do
  let(:exchange) { 'orders' }
  let(:routing_key) { 'order.created' }
  let(:order) { create(:order) }

  let(:mock_channel) { instance_double(Bunny::Channel) }
  let(:mock_exchange) { instance_double(Bunny::Exchange) }
  let(:mock_connection) do
    instance_double(Bunny::Session, start: true, create_channel: mock_channel, close: true, open?: true)
  end

  before do
    allow(Bunny).to receive(:new).and_return(mock_connection)
    allow(mock_channel).to receive(:topic).with(exchange, durable: true).and_return(mock_exchange)
    allow(mock_exchange).to receive(:publish)
  end

  it 'publishes a created order event' do
    publisher = described_class.new(exchange: exchange, routing_key: routing_key)

    expect(mock_exchange).to receive(:publish).with(
        a_string_matching(/"event":"order\.created"/),
        hash_including(routing_key: routing_key)
      )

    publisher.publish_created(order)
  end
end
