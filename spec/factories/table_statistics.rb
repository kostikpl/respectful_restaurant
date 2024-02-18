FactoryBot.define do
  factory :table_statistic do
    customer_id { 1 }
    dishes_count { 1 }
    total_bill_cents { 1 }
    time_spent_seconds { 1 }
  end
end
