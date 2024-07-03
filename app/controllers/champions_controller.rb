require 'httparty'

class ChampionsController < ApplicationController
  before_action :set_champion_list, only: [:index]

  def index
  end

  def champion_masteries
    riot_id = params[:riot_id]
    tagline = params[:tagline]

    # Ottenere il PUUID usando RiotID e tagline
    puuid_response = HTTParty.get("https://europe.api.riotgames.com/riot/account/v1/accounts/by-riot-id/#{riot_id}/#{tagline}?api_key=#{ENV['RIOT_API_KEY']}")
    puuid_data = JSON.parse(puuid_response.body)

    if puuid_data["puuid"]
      puuid = puuid_data["puuid"]
      @mastery_data = get_mastery_data(puuid)

      # Ordinare i campioni in base ai punti maestria in ordine decrescente
      @mastery_data.sort_by! { |data| -data["championPoints"] }
    else
      flash[:alert] = "Invalid Riot ID or Tagline"
      redirect_to champions_path and return
    end
  end

  private

  def set_champion_list
    response = HTTParty.get("http://ddragon.leagueoflegends.com/cdn/#{latest_patch}/data/en_US/champion.json")
    @champions = JSON.parse(response.body)["data"]
  end

  def get_mastery_data(puuid)
    region = 'euw1' # Esempio: 'na1'
    response = HTTParty.get("https://#{region}.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-puuid/#{puuid}?api_key=#{ENV['RIOT_API_KEY']}")
    JSON.parse(response.body)
  end

  def latest_patch
    response = HTTParty.get("https://ddragon.leagueoflegends.com/api/versions.json")
    JSON.parse(response.body).first
  end
end