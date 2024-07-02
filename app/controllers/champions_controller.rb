class ChampionsController < ApplicationController
  def index
    @champions = fetch_champions
  end

  def show
    @champion_id = params[:id]
    @champion_name = fetch_champion_name(@champion_id)
    @players = fetch_players_for_champion(@champion_id).sort_by { |player| -player['score'] }
  end

  private

  def fetch_champions
    response = RestClient.get("http://localhost:5000/champions")
    JSON.parse(response.body).map { |key, value| { "id" => key, "name" => value["name"] } }
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error("Error fetching champions: #{e.response}")
    []
  end

  def fetch_champion_name(champion_id)
    champions = fetch_champions
    champion = champions.find { |c| c["id"] == champion_id }
    champion ? champion["name"] : "Unknown Champion"
  end

  def fetch_players_for_champion(champion_id)
    response = RestClient.get("http://localhost:5000/champions/#{champion_id}/players")
    JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error("Error fetching players for champion #{champion_id}: #{e.response}")
    []
  end

  def show
    @champion_id = params[:id]
    @champion_name = fetch_champion_name(@champion_id)
    @players = fetch_players_for_champion(@champion_id).sort_by { |player| -player['score'] }
  
    logger.debug("Champion ID: #{@champion_id}")
    logger.debug("Champion Name: #{@champion_name}")
    logger.debug("Players: #{@players}")
  end
  
end
