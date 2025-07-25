class OrderItem < ApplicationRecord
  belongs_to :order

  validates :product_name, :quantity, :price, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }
end