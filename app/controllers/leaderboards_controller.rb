class LeaderboardsController < ApplicationController
    
    require 'http'
    
    def index
      @lol_leaderboard = fetch_lol_leaderboard
      process_leaderboard_data if @lol_leaderboard
    end
    
    private
    
    def fetch_lol_leaderboard
      response = HTTParty.get("https://euw1.api.riotgames.com/lol/league/v4/challengerleagues/by-queue/RANKED_SOLO_5x5?api_key=RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9")
      response.parsed_response if response.success?
    end
  
    def process_leaderboard_data
      @lol_leaderboard['entries'].each do |player|
        player['winRate'] = calculate_win_rate(player)
      end
      @lol_leaderboard['entries'].sort_by! { |player| -player['leaguePoints'] }
    end
  
    def calculate_win_rate(player)
      total_games = player['wins'] + player['losses']
      return 0 if total_games == 0
      ((player['wins'].to_f / total_games) * 100).round(2)
    end
  end
  