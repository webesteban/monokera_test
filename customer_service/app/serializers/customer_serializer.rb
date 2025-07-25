class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :orders_count,
             :email, :phone_number, :status, :registered_at
end
