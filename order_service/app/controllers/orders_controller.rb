class OrdersController < ApplicationController
  rescue_from Orders::Create::CustomerNotFoundError, Orders::List::CustomerNotFoundError do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create
    order = Orders::Create.new(order_params).call
    render json: order, serializer: OrderSerializer, status: :created
  end

  def index
    orders = Orders::List.new(
      customer_id: params[:customer_id],
      page: params[:page],
      per_page: params[:per_page]
    ).call
    render json: orders, each_serializer: OrderSerializer, status: :ok
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, :product_name, :quantity, :price, :status)
  end
end
