class Order < ApplicationRecord
  attr_accessor :customer_data
  
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items

  enum status: {
      pending: "pending",
      confirmed: "confirmed",
      shipped: "shipped",
      cancelled: "cancelled"
    }, _prefix: true
  
  validates :customer_id, :status, presence: true
  validates :status, inclusion: { in: statuses.keys }
end
