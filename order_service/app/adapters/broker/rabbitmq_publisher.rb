module Broker
  class RabbitmqPublisher < Events::OrderEventPublisher
    def initialize(exchange:, routing_key:)
      @exchange_name = exchange
      @routing_key = routing_key
      @url = ENV['RABBITMQ_URL']
      @connection = Bunny.new(@url)
      @connection.start
      @channel = @connection.create_channel
      @exchange = @channel.topic(@exchange_name, durable: true)
    end

    def publish_created(order)
      payload = {
        event: 'order.created',
        data: order.as_json
      }

      @exchange.publish(
        payload.to_json,
        routing_key: @routing_key,
        content_type: 'application/json',
        persistent: true
      )
    ensure
      @connection.close if @connection.open?
    end
  end
end
