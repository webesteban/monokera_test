class OrdersController < ApplicationController
  rescue_from Orders::Create::CustomerNotFoundError, Orders::List::CustomerNotFoundError do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create
    order = Orders::Create.call(order_params)
    render json: order, serializer: OrderSerializer, status: :created
  end

  def index
    orders = Orders::List.call(
      customer_id: params[:customer_id],
      page: params[:page],
      per_page: params[:per_page]
    )
    render json: orders, each_serializer: OrderSerializer, status: :ok
  end

  private

  def order_params
    params.require(:order).permit(
      :customer_id, 
      :status,
      order_items_attributes: [:product_name, :quantity, :price]
    )
  end
end
