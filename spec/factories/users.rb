FactoryBot.define do
  factory :user do
    name { "Вася#{rand(999)}" }

    sequence(:email) { |n| "user#{n}@example.com" }
    password {'password'}
    password_confirmation {'password'}
  end
end
