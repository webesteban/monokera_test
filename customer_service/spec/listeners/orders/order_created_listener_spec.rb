
require 'rails_helper'

RSpec.describe Orders::OrderCreatedListener do
  let(:payload) { { data: { customer_id: 1 } }.to_json }
  let(:mock_consumer) { instance_double(Broker::RabbitmqConsumer) }
  let(:handler) { instance_double(Orders::HandleCreated) }

  before do
    allow(Broker::RabbitmqConsumer).to receive(:new).and_return(mock_consumer)
    allow(mock_consumer).to receive(:subscribe).and_yield(payload)
    allow(Orders::HandleCreated).to receive(:new).and_return(handler)
    allow(handler).to receive(:call)
  end

  it 'calls the Orders::HandleCreated with event data' do
    listener = described_class.new(consumer: mock_consumer)
    expect(handler).to receive(:call)
    listener.call
  end
end
