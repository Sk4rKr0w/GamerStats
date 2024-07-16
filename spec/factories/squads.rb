FactoryBot.define do
  factory :squad do
    sequence(:name) { |n| "Squad #{n}" }
    user_id {1}
    saved { true }
    description { "squad #{name.split.last}" }
    creator_name { "Niko" }

    trait :with_players do
      transient do
        players_count { 5 }
      end

      after(:create) do |squad, evaluator|
        create_list(:player, evaluator.players_count, squad: squad)
      end
    end
  end
end
