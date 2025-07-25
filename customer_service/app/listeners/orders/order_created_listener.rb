module Orders
  class OrderCreatedListener
    def initialize(consumer: Broker::RabbitmqConsumer.new(queue: 'order.created', exchange: 'orders.exchange', routing_key: 'orders.created'))
      @consumer = consumer
    end

    def call
      puts '[*] Listening for order.created events...'
      @consumer.subscribe do |message|
        puts "[x] Received message: #{message.inspect}"
        event = JSON.parse(message, symbolize_names: true)
        Orders::HandleCreated.new(event[:data]).call
        puts "[✓] Event processed"
      rescue => e
        puts "[!] Error processing event: #{e.class} - #{e.message}"
        puts e.backtrace.take(5).join("\n")
      end
    end
  end
end
