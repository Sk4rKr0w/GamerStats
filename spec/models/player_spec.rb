require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'associations' do
    it { should belong_to(:squad) }
  end

  describe 'callbacks' do
    let(:player) { FactoryBot.build(:player) }

    it 'initializes stats before save' do
      player.save
      expect(player.win_rate).to eq(33.33)
      expect(player.kills).to eq(7.5)
      expect(player.deaths).to eq(4.87)
      expect(player.assists).to eq(8.93)
    end
  end

  describe '#fetch_details' do
    let(:player) { FactoryBot.create(:player) }

    before do
      stub_request(:get, /https:\/\/europe.api.riotgames.com\/riot\/account\/v1\/accounts\/by-riot-id\/NikoChaos01\/2912\?api_key=/)
        .to_return(
          status: 200,
          body: { puuid: 'XqWN8mVYAy3CnBV3r8K82XrHPOP3l58peKOgwrEtJ9H0U3EL98Ofdeecg5UJ7L0l841U-Tkrs7lLtw' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      stub_request(:get, /https:\/\/europe.api.riotgames.com\/lol\/match\/v5\/matches\/by-puuid\/XqWN8mVYAy3CnBV3r8K82XrHPOP3l58peKOgwrEtJ9H0U3EL98Ofdeecg5UJ7L0l841U-Tkrs7lLtw\/ids\?start=0&count=15&api_key=/)
        .to_return(
          status: 200,
          body: ['match1', 'match2'].to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      stub_request(:get, /https:\/\/europe.api.riotgames.com\/lol\/match\/v5\/matches\/match1\?api_key=/)
        .to_return(
          status: 200,
          body: {
            info: {
              participants: [
                { puuid: 'XqWN8mVYAy3CnBV3r8K82XrHPOP3l58peKOgwrEtJ9H0U3EL98Ofdeecg5UJ7L0l841U-Tkrs7lLtw', kills: 10, deaths: 2, assists: 5, win: true }
              ]
            }
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      stub_request(:get, /https:\/\/europe.api.riotgames.com\/lol\/match\/v5\/matches\/match2\?api_key=/)
        .to_return(
          status: 200,
          body: {
            info: {
              participants: [
                { puuid: 'XqWN8mVYAy3CnBV3r8K82XrHPOP3l58peKOgwrEtJ9H0U3EL98Ofdeecg5UJ7L0l841U-Tkrs7lLtw', kills: 5, deaths: 3, assists: 8, win: false }
              ]
            }
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'fetches and updates player details' do
      player.fetch_details
      player.reload

      expect(player.puuid).to eq('XqWN8mVYAy3CnBV3r8K82XrHPOP3l58peKOgwrEtJ9H0U3EL98Ofdeecg5UJ7L0l841U-Tkrs7lLtw')
      expect(player.kills).to eq(4.53) # (10 + 5) / 2
      expect(player.deaths).to eq(4.87) # (2 + 3) / 2
      expect(player.assists).to eq(8.93) # (5 + 8) / 2
      expect(player.win_rate).to eq(33.33) # 1 win out of 2 matches
    end
  end
end
