class Order < ApplicationRecord
  enum status: {
      pending: "pending",
      confirmed: "confirmed",
      shipped: "shipped",
      cancelled: "cancelled"
    }, _prefix: true
  
  validates :customer_id, :product_name, :quantity, :price, :status, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }
  validates :status, inclusion: { in: statuses.keys }
end
