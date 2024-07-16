# spec/controllers/players_controller_spec.rb
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe PlayersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET #search" do
    let(:valid_params) do
      { game_name: "NikoChaos01", tag_line: "2912", region: "europe", server: "euw1" }
    end

    before do
      stub_request(:get, "https://europe.api.riotgames.com/riot/account/v1/accounts/by-riot-id/NikoChaos01/2912").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'europe.api.riotgames.com',
            'User-Agent'=>'Ruby',
            'X-Riot-Token'=>'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9'
          }).
        to_return(status: 200, body: '{"puuid": "some_puuid"}', headers: {})

      stub_request(:get, "https://euw1/lol/summoner/v4/summoners/by-puuid/some_puuid").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'euw1',
            'User-Agent'=>'Ruby',
            'X-Riot-Token'=>'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9'
          }).
        to_return(status: 200, body: '{"id": "some_id", "profileIconId": 1234}', headers: {})

      stub_request(:get, "https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/some_puuid/ids").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'europe.api.riotgames.com',
            'User-Agent'=>'Ruby',
            'X-Riot-Token'=>'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9'
          }).
        to_return(status: 200, body: '["match1", "match2"]', headers: {})

      stub_request(:get, "https://europe.api.riotgames.com/lol/match/v5/matches/match1").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'europe.api.riotgames.com',
            'User-Agent'=>'Ruby',
            'X-Riot-Token'=>'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9'
          }).
        to_return(status: 200, body: '{"info": {"participants": [{"puuid": "some_puuid", "win": true, "kills": 10, "deaths": 2, "assists": 5, "championName": "Aatrox"}], "gameDuration": 1800}}', headers: {})

      stub_request(:get, "https://europe.api.riotgames.com/lol/match/v5/matches/match2").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'europe.api.riotgames.com',
            'User-Agent'=>'Ruby',
            'X-Riot-Token'=>'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9'
          }).
        to_return(status: 200, body: '{"info": {"participants": [{"puuid": "some_puuid", "win": false, "kills": 7, "deaths": 3, "assists": 4, "championName": "Ahri"}], "gameDuration": 1600}}', headers: {})

      stub_request(:get, "https://euw1/lol/league/v4/entries/by-summoner/some_id").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'euw1',
            'User-Agent'=>'Ruby',
            'X-Riot-Token'=>'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9'
          }).
        to_return(status: 200, body: '[{"tier": "Gold", "rank": "IV", "leaguePoints": 50}]', headers: {})
    end

    it "returns a redirect response" do
      get :search, params: valid_params
      expect(response).to have_http_status(:redirect)
    end

    it "redirects to the player show path" do
      get :search, params: valid_params
      expect(response).to redirect_to(player_show_path(
        player_data: { 'puuid' => 'some_puuid' },
        region: valid_params[:region],
        matches: [
          { match_id: 'match1', score: '10/2/5', duration: 1800, win: 'Victory', champion_name: 'Aatrox' },
          { match_id: 'match2', score: '7/3/4', duration: 1600, win: 'Defeat', champion_name: 'Ahri' }
        ],
        win_rate: 50.0,
        summoner_data: { 'id' => 'some_id', 'profileIconId' => 1234, 'profileIconUrl' => '/assets/profileicon/1234.png' },
        rank_data: [{ 'tier' => 'Gold', 'rank' => 'IV', 'leaguePoints' => 50 }]
      ))
    end
  end

  describe "private methods" do
    let(:controller) { PlayersController.new }
    let(:api_key) { 'test_api_key' }

    describe "#calculate_win_rate" do
      it "calculates the win rate correctly" do
        expect(controller.send(:calculate_win_rate, 5, 10)).to eq(50.0)
        expect(controller.send(:calculate_win_rate, 0, 10)).to eq(0.0)
        expect(controller.send(:calculate_win_rate, 7, 10)).to eq(70.0)
      end
    end

    describe "#perform_request" do
      it "performs a request and returns the response" do
        stub_request(:get, "https://test.api/endpoint").
          to_return(status: 200, body: '{"key": "value"}')

        url = URI("https://test.api/endpoint")
        response = controller.send(:perform_request, url, api_key)
        expect(response.code).to eq("200")
        expect(JSON.parse(response.body)).to eq({ "key" => "value" })
      end
    end
  end
end
