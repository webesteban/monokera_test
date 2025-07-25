module Customers
  class FetchCustomer < ApplicationService
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def call
      Customer.find(id)
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end
  