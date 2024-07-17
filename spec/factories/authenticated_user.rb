FactoryBot.define do
  factory :authenticated_user, class: 'User' do
    email { "admin@examples.com" }
    password { "Password123!" }
    password_confirmation { "Password123!" }
    confirmed_at { Time.now }
    two_factor_enabled { false }  # Aggiungi questa linea

    trait :admin do
      admin { true }
    end

    trait :banned do
      banned { false }
    end

    factory :admin_authenticated_user, traits: [:admin]
    factory :banned_authenticated_user, traits: [:banned]
  end
end
