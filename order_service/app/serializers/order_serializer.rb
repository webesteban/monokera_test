class OrderSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :status, :created_at, :updated_at, :customer

  has_many :order_items

  class OrderItemSerializer < ActiveModel::Serializer
    attributes :product_name, :quantity, :price
  end

  def customer
    object.customer_data || {}
  end
end