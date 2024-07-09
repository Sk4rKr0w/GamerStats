require 'net/http'

class Player < ApplicationRecord
  belongs_to :squad

  def fetch_details
    api_key = "RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9"
    uri = URI("https://europe.api.riotgames.com/riot/account/v1/accounts/by-riot-id/#{riot_id}/#{game_tag}?api_key=#{api_key}")
    response = Net::HTTP.get(uri)
    details = JSON.parse(response)
    update(puuid: details['puuid'])
    details
  rescue StandardError => e
    Rails.logger.error "Error fetching player details: #{e.message}"
    nil
  end
end
