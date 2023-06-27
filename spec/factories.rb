FactoryBot.define do
  factory(:field) do
    name { Faker::Name }
    # shape
    area { rand(1..1000) }
  end
end
