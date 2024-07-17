FactoryBot.define do
  factory :player do
    riot_id { "NikoChaos01" }
    game_tag { "2912" }
    puuid { "XqWN8mVYAy3CnBV3r8K82XrHPOP3l58peKOgwrEtJ9H0U3EL98Ofdeecg5UJ7L0l841U-Tkrs7lLtw" }
    win_rate { 33.33 }
    kills { 4.53 }
    deaths { 4.87 }
    assists { 8.93 }
    association :squad
  end
end
