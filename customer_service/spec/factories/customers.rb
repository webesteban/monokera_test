FactoryBot.define do
  factory :customer do
    name { "MyString" }
    address { "MyString" }
    orders_count { 1 }
    email { "MyString" }
    phone_number { "MyString" }
    status { "active" }
    registered_at { "2025-07-25 00:23:11" }
  end
end
