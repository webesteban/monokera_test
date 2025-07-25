FactoryBot.define do
  factory :order do
    customer_id { 1 }

    status { "pending" }

    transient do
      items_count { 1 }
    end

    after(:build) do |order, evaluator|
      order.order_items = build_list(:order_item, evaluator.items_count, order: order)
    end
  end
end
