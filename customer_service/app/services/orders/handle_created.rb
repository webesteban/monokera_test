module Orders
  class HandleCreated < ApplicationService
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def call
      customer = Customer.find_by(id: data[:customer_id])
      return unless customer

      customer.increment!(:orders_count)
    end
  end
end