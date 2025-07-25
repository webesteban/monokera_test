class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address
      t.integer :orders_count, null: false, default: 0
      t.string :email
      t.string :phone_number
      t.string :status, null: false, default: "active"
      t.datetime :registered_at, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamps
    end
  end
end
