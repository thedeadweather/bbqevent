FactoryBot.define do
  factory :event do
    title { 'Test' }
    address { 'somewhere' }
    datetime { Time.now }
    association :user
  end
end
