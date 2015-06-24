FactoryGirl.define do
  factory :line_item do
    order nil
    item
    quantity 1
    price_at_purchase 1
  end
end
