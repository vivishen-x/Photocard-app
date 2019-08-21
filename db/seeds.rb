Employee.create!(name: "Example User",
                 email: "example-01@wamazing.jp",
                 position: "Translator",
                 employed_at: 1.month.ago,
                 password: "password",
                 password_confirmation: "password")

49.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@wamazing.jp"
  position = "Marketing"
  employed_at = n.months.ago
  Employee.create!(name: name,
                   email: email,
                   position: position,
                   employed_at: employed_at,
                   password: "password",
                   password_confirmation: "password")
end
