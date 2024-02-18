FactoryBot.define do
  factory :reservation do
    starts_at { 1.day.from_now}
    ends_at { 1.day.from_now + 1.hour }
    table_id { rand(0..100) }
    client_id { rand(0..100) }
  end
end
