FactoryBot.define do
  factory :menu_item do
    title { Faker::Food.dish }
    price_cents { rand(100..10_000) }
  end
end
