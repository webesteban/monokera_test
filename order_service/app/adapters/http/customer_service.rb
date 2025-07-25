module Http
  class CustomerService < Clients::CustomerServiceClient
    def initialize
      @base_url = ENV['CUSTOMER_SERVICE_URL']
    end

    def fetch_customer(customer_id)
      response = Faraday.get("#{@base_url}/customers/#{customer_id}")
      return nil unless response.status == 200

      JSON.parse(response.body)
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError
      nil
    end
  end
end
