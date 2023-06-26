FactoryBot.define do
  factory(:field) do
    name { Faker::Name }
    # shape
    area { 0..5 }
  end
end
