FactoryBot.define do
  factory :order do
    quantity { 1 }
    menu_item { nil }
    reservation { nil }
  end
end
