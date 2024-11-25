class Player < ApplicationRecord
  belongs_to :squad

  before_save :initialize_stats

  def fetch_details
    api_key = ENV['RIOT_API_KEY']
    puuid_uri = URI("https://europe.api.riotgames.com/riot/account/v1/accounts/by-riot-id/#{riot_id}/#{game_tag}?api_key=#{api_key}")
    puuid_response = Net::HTTP.get(puuid_uri)
    puuid_details = JSON.parse(puuid_response)

    if puuid_details && puuid_details['puuid'].present?
      update(puuid: puuid_details['puuid'])

      match_ids_uri = URI("https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/#{puuid}/ids?start=0&count=15&api_key=#{api_key}")
      match_ids_response = Net::HTTP.get(match_ids_uri)
      match_ids = JSON.parse(match_ids_response)

      total_kills = 0
      total_deaths = 0
      total_assists = 0
      total_wins = 0
      total_matches = match_ids.size

      match_ids.each do |match_id|
        match_uri = URI("https://europe.api.riotgames.com/lol/match/v5/matches/#{match_id}?api_key=#{api_key}")
        match_response = Net::HTTP.get(match_uri)
        match_details = JSON.parse(match_response)
        participant = match_details['info']['participants'].find { |p| p['puuid'] == puuid }

        if participant
          total_kills += participant['kills']
          total_deaths += participant['deaths']
          total_assists += participant['assists']
          total_wins += 1 if participant['win']
        end
      end

      avg_kills = (total_kills / total_matches.to_f).round(2)
      avg_deaths = (total_deaths / total_matches.to_f).round(2)
      avg_assists = (total_assists / total_matches.to_f).round(2)
      win_rate = ((total_wins / total_matches.to_f) * 100).round(2)

      update(kills: avg_kills, deaths: avg_deaths, assists: avg_assists, win_rate: win_rate)

      details
    else
      Rails.logger.error "PUUID not found or API response is invalid"
      nil
    end
  rescue StandardError => e
    Rails.logger.error "Error fetching player details: #{e.message}"
    nil
  end

  private

  def initialize_stats
    self.win_rate ||= 0.0
    self.kills ||= 0.0
    self.deaths ||= 0.0
    self.assists ||= 0.0
  end
end
