module Broker
  class RabbitmqConsumer
    def initialize(queue:, exchange:, routing_key:)
      @url = ENV['RABBITMQ_URL']
      puts "[*] Connecting to RabbitMQ at #{@url}..."

      @connection = Bunny.new(@url)
      @connection.start

      @channel = @connection.create_channel
      @exchange = @channel.topic(exchange, durable: true)
      @queue = @channel.queue(queue, durable: true)

      puts "[*] Binding queue '#{queue}' to exchange '#{exchange}' with routing key '#{routing_key}'"
      @queue.bind(@exchange, routing_key: routing_key)
    end

    def subscribe(&block)
      puts "[*] Subscribing to queue #{@queue.name}..."
      @queue.subscribe(block: true, manual_ack: false) do |_delivery_info, _properties, payload|
        puts "[→] Received message: #{payload}"
        block.call(payload)
      end
    end
  end
end
