FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "Password123!" }
    confirmed_at { Time.now }

    trait :admin do
      email { "admin@example.com" }
      password { "Admin123!" }
      admin { true }
    end
  end
end
