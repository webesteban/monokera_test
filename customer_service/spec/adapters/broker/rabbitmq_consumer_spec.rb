require 'rails_helper'

RSpec.describe Broker::RabbitmqConsumer do
  let(:queue_name) { 'order.created' }
  let(:exchange_name) { 'orders' }
  let(:routing_key) { 'order.created' }

  let(:mock_connection) { instance_double(Bunny::Session, start: true, create_channel: mock_channel) }
  let(:mock_channel) { instance_double(Bunny::Channel, topic: mock_exchange, queue: mock_queue) }
  let(:mock_exchange) { instance_double(Bunny::Exchange) }
  let(:mock_queue) { instance_double(Bunny::Queue) }

  subject(:consumer) do
    described_class.new(queue: queue_name, exchange: exchange_name, routing_key: routing_key)
  end

  before do
    allow(Bunny).to receive(:new).and_return(mock_connection)
    allow(mock_queue).to receive(:bind)
    allow(mock_queue).to receive(:name).and_return(queue_name)
  end

  describe '#subscribe' do
    it 'subscribes to the queue and yields messages' do
      payload = { data: 'test' }.to_json

      expect(mock_queue).to receive(:subscribe).with(block: true, manual_ack: false).and_yield(nil, nil, payload)

      result = nil
      consumer.subscribe do |message|
        result = message
      end

      expect(result).to eq(payload)
    end
  end
end
