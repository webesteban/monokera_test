class CustomersController < ApplicationController
  
  def index
    customers = Customers::FetchAll.call
    render json: customers, each_serializer: CustomerSerializer, status: :ok
  end

  def show
    customer = Customers::FetchCustomer.call(params[:id])
    if customer
      render json: customer, serializer: CustomerSerializer, status: :ok
    else
      render json: { error: "Customer not found" }, status: :not_found
    end
  end
end
