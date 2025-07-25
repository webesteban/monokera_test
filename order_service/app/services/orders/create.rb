module Orders
  class Create < ApplicationService
    class CustomerNotFoundError < Orders::Error; end

    attr_reader :params, :publisher, :customer_client

    def initialize(params, publisher: nil, customer_client: nil)
      @params = params
      @publisher = publisher
      @customer_client = customer_client
    end

    def call
      validate_customer!
      order = Order.create!(params)
      publisher.publish_created(order)
      order
    rescue ActiveRecord::RecordInvalid => e
      raise e
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError
      raise CustomerNotFoundError, "Customer service unavailable"
    end

    private

    def customer_client
      @customer_client ||= Http::CustomerService.new
    end

    def publisher
      @publisher ||= Broker::RabbitmqPublisher.new(
        exchange: 'orders.exchange',
        routing_key: 'orders.created'
      )
    end

    def validate_customer!
      customer = customer_client.fetch_customer(params[:customer_id])
      raise CustomerNotFoundError, "Customer not found" if customer.nil?
    end
  end
end