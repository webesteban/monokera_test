FactoryBot.define do
  factory :order_item do
    order { build(:order) }
    product_name { "MyString" }
    quantity { 1 }
    price { "9.99" }
  end
end
