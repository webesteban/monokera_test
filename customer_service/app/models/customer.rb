class Customer < ApplicationRecord
  enum status: { active: 'active', inactive: 'inactive', suspended: 'suspended' }, _suffix: true

  validates :name, presence: true
  validates :status, inclusion: { in: statuses.keys }
end