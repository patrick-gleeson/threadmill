FactoryGirl.define do
  factory :order do
    association :user, factory: :other_user
  end
end
