module Customers
  class FetchAll < ApplicationService
    def call
      Customer.all
    end
  end
end