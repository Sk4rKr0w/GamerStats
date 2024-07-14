# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: :show
  require 'net/http'
  require 'json'

  def show
    api_key = 'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9'
    api_region = @user.continent
    game_name = @user.riot_id
    tag_line = @user.riot_tagline
    server = @user.region

    @errors = []

    if game_name.blank? || tag_line.blank?
      @errors << "riot_id or riot_tagline not found"
    else
      # Prima chiamata API per ottenere il PUUID
      begin
        puuid_url = URI("https://#{api_region}.api.riotgames.com/riot/account/v1/accounts/by-riot-id/#{game_name}/#{tag_line}?api_key=#{api_key}")
        puuid_response = Net::HTTP.get(puuid_url)
        account_data = JSON.parse(puuid_response)

        if account_data['status'] && account_data['status']['status_code'] != 200
          @errors << account_data['status']['message']
        else
          puuid = account_data['puuid']
        end
      rescue => e
        @errors << "Error fetching PUUID: #{e.message}"
      end

      # Seconda chiamata API per ottenere i dati del summoner
      if puuid
        begin
          summoner_url = URI("https://#{server}.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/#{puuid}?api_key=#{api_key}")
          summoner_response = Net::HTTP.get(summoner_url)
          @summoner_data = JSON.parse(summoner_response)

          if @summoner_data['status'] && @summoner_data['status']['status_code'] != 200
            @errors << @summoner_data['status']['message']
          end
        rescue => e
          @errors << "Error fetching summoner data: #{e.message}"
        end
      end

      # Terza chiamata API per ottenere i dati della lega
      if puuid
        begin
          league_url = URI("https://#{server}.api.riotgames.com/lol/league/v4/entries/by-summoner/#{summoner_id}?api_key=#{api_key}")
          league_response = Net::HTTP.get(league_url)
          @league_data = JSON.parse(league_response)

          if @league_data.is_a?(Array) && @league_data.empty?
            @errors << "No league data found."
          elsif @league_data.is_a?(Hash) && @league_data['status'] && @league_data['status']['status_code'] != 200
            @errors << "Error fetching league data: #{@league_data['status']['message']} (status code: #{@league_data['status']['status_code']})"
          else
            # Calcolo del winrate delle ranked
            ranked_wins = 0
            ranked_losses = 0

            if @league_data.is_a?(Array)
              @league_data.each do |entry|
                ranked_wins += entry['wins']
                ranked_losses += entry['losses']
              end
            end

            @ranked_winrate = if (ranked_wins + ranked_losses) > 0
                                (ranked_wins.to_f / (ranked_wins + ranked_losses) * 100).round(0)
                              else
                                0
                              end
          end
        rescue => e
          @errors << "Error fetching league data: #{e.message}"
        end
      end

      # Quarta chiamata API per ottenere i match IDs
      if puuid
        begin
          matches_url = URI("https://#{api_region}.api.riotgames.com/lol/match/v5/matches/by-puuid/#{puuid}/ids?api_key=#{api_key}&count=20")
          matches_response = Net::HTTP.get(matches_url)
          @match_ids = JSON.parse(matches_response)

          if @match_ids.is_a?(Hash) && @match_ids['status'] && @match_ids['status']['status_code'] != 200
            @errors << @match_ids['status']['message']
          end
        rescue => e
          @errors << "Error fetching match IDs: #{e.message}"
        end
      end

      # Quinta chiamata API per ottenere i dettagli di ogni partita
      if @match_ids
        begin
          @matches_details = @match_ids.map do |match_id|
            match_url = URI("https://#{api_region}.api.riotgames.com/lol/match/v5/matches/#{match_id}?api_key=#{api_key}")
            match_response = Net::HTTP.get(match_url)
            match_data = JSON.parse(match_response)

            if match_data['status'] && match_data['status']['status_code'] != 200
              next { error: match_data['status']['message'] }
            end

            participant = match_data['info']['participants'].find { |p| p['puuid'] == puuid }

            {
              match_id: match_id,
              score: "#{participant['kills']}/#{participant['deaths']}/#{participant['assists']}",
              duration: match_data['info']['gameDuration'],
              outcome: participant['win'] ? 'Win' : 'Defeat',
              champion_name: participant['championName'],
              win: participant['win']
            }
          end.compact

          # Calcolo del winrate delle ultime 20 partite
          recent_wins = @matches_details.count { |match| match[:win] }
          @recent_winrate = if @matches_details.size > 0
                              (recent_wins.to_f / @matches_details.size * 100).round(0)
                            else
                              0
                            end
        rescue => e
          @errors << "Error fetching match details: #{e.message}"
        end
      end
    end
  rescue ActiveRecord::RecordNotFound
    @errors << "User not found."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
