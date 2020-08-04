FactoryBot.define do
  factory :identity do
    user { nil }
    provider { "MyString" }
    url { "MyString" }
  end
end
