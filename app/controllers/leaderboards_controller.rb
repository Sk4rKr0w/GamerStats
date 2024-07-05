class LeaderboardsController < ApplicationController
  require 'http'

  def new
    @continent = params[:continent] || 'europe'
    @server = params[:server]  || 'euw1'
  end

  def index
    @server = params[:server]
    @lol_leaderboard = fetch_lol_leaderboard(@server)
    process_leaderboard_data if @lol_leaderboard
  end

  private

  def fetch_lol_leaderboard(server)
    api_key = 'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9'
    response = HTTParty.get("https://#{server}.api.riotgames.com/lol/league/v4/challengerleagues/by-queue/RANKED_SOLO_5x5?api_key=#{api_key}")
    response.parsed_response if response.success?
  end

  def process_leaderboard_data
    @lol_leaderboard['entries'].each do |player|
      player['winRate'] = calculate_win_rate(player)
      player['summonerName'] = fetch_game_name(player['summonerId'])
    end
    @lol_leaderboard['entries'].sort_by! { |player| -player['leaguePoints'] }
    @lol_leaderboard['entries'] = @lol_leaderboard['entries'].first(5)
  end

  def calculate_win_rate(player)
    total_games = player['wins'] + player['losses']
    return 0 if total_games.zero?
    ((player['wins'].to_f / total_games) * 100).round(2)
  end

  def fetch_game_name(summoner_id)
    api_key = 'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9'
    summoner_response = HTTParty.get("https://#{@server}.api.riotgames.com/lol/summoner/v4/summoners/#{summoner_id}?api_key=#{api_key}")
    if summoner_response.success?
      puuid = summoner_response.parsed_response['puuid']
      account_response = HTTParty.get("https://europe.api.riotgames.com/riot/account/v1/accounts/by-puuid/#{puuid}?api_key=#{api_key}")
      return account_response.parsed_response['gameName'] if account_response.success?
    end
    nil
  end
end 