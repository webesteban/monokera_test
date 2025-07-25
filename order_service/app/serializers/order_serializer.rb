class OrderSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :product_name, :quantity, :price, :status, :created_at, :updated_at
end