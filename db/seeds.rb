Employee.create!(name: "Admin User",
                 email: "example-01@wamazing.jp",
                 position: "Translator",
                 employed_at: 1.month.ago,
                 password: "password",
                 password_confirmation: "password",
                 admin: true,
                 activated: true,
                 activated_at: Time.zone.now)

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
                   password_confirmation: "password",
                   activated: true,
                   activated_at: Time.zone.now)
end

Team.create!(name: "Yado")
Team.create!(name: "Snow")
Team.create!(name: "Ticket")
Team.create!(name: "Shopping")

50.times do |n|
  TeamEmployee.create!(employee_id: n + 1,
                        team_id: n%4 + 1)
end
