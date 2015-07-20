FactoryGirl.define do
  factory :user do
    name 'Bob'
    email 'test@example.com'
    password '12345678'
    password_confirmation '12345678'
  end
  factory :other_user, class: User do
    name 'Alice'
    email 'alice@example.com'
    password '12345678'
    password_confirmation '12345678'
  end
end
