module Orders
  class List < ApplicationService
    class CustomerNotFoundError < Orders::Error; end

    attr_reader :customer_id, :page, :per_page

    def initialize(customer_id:, page: 1, per_page: 20, customer_client: nil)
      @customer_id = customer_id
      @page = page
      @per_page = per_page
      @customer_client = customer_client
    end

    def call
      validate_customer!
      Order.where(customer_id: customer_id).page(page).per(per_page)


    end

    private

    def customer_client
      @customer_client ||= Http::CustomerService.new
    end

    def validate_customer!
      customer = customer_client.fetch_customer(customer_id)
      raise CustomerNotFoundError, "Customer not found" if customer.nil?
    end
  end
end