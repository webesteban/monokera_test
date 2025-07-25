class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.string :status, null: false, default: "pending"
      t.timestamps
    end
  end
end
