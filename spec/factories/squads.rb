FactoryBot.define do
  factory :squad do
    sequence(:name) { |n| "Squad #{n}" }
    association :user
    saved { true }
    description { |s| "squad #{s.name ? s.name.split.last : 'default'}" }
    creator_name { "Niko" }

    trait :with_players do
      transient do
        players_count { 5 }
      end

      after(:build) do |squad, evaluator|
        squad.players = build_list(:player, evaluator.players_count, squad: squad)
      end

      after(:create) do |squad, evaluator|
        squad.players.each(&:save!)
      end
    end
  end
end
