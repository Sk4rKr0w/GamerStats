class Player < ApplicationRecord
  belongs_to :squad

  API_KEY = "RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9"

  def fetch_details
    uri = URI("https://europe.api.riotgames.com/riot/account/v1/accounts/by-riot-id/#{riot_id}/#{game_tag}?api_key=#{API_KEY}")
    response = Net::HTTP.get(uri)
    details = JSON.parse(response)
    update(puuid: details['puuid'])
    update_win_rate
    details
  rescue StandardError => e
    Rails.logger.error "Error fetching player details: #{e.message}"
    nil
  end

  def update_win_rate
    match_ids = fetch_match_ids
    return if match_ids.nil?

    total_matches = match_ids.size
    return if total_matches.zero?

    wins = match_ids.count { |match_id| fetch_match_details(match_id) }

    win_rate = (wins.to_f / total_matches) * 100
    update(win_rate: win_rate)
  rescue StandardError => e
    Rails.logger.error "Error updating win rate: #{e.message}"
    nil
  end

  private

  def fetch_match_ids
    uri = URI("https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/#{puuid}/ids?api_key=#{API_KEY}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue StandardError => e
    Rails.logger.error "Error fetching match IDs: #{e.message}"
    nil
  end

  def fetch_match_details(match_id)
    uri = URI("https://europe.api.riotgames.com/lol/match/v5/matches/#{match_id}?api_key=#{API_KEY}")
    response = Net::HTTP.get(uri)
    match_details = JSON.parse(response)
    participant = match_details['info']['participants'].find { |p| p['puuid'] == puuid }
    participant['win']
  rescue StandardError => e
    Rails.logger.error "Error fetching match details: #{e.message}"
    false
  end
end
