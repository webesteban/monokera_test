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
      customer = find_customer
      order = Order.create!(params)
      order.customer_data = customer
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

    def find_customer
      customer = customer_client.fetch_customer(params[:customer_id])
      raise CustomerNotFoundError, "Customer not found" if customer.nil?
      customer
    end
  end
end