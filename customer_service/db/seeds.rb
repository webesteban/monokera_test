10.times do |i|
    Customer.create!(
      name: "Cliente #{i + 1}",
      address: "Calle #{100 + i}",
      orders_count: 0,
      email: "cliente#{i + 1}@monokera.com",
      phone_number: "555-#{1000 + i}",
      status: %w[active inactive suspended].sample,
      registered_at: Time.current - rand(1..10).days
    )
  end