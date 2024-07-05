require 'httparty'

class ChampionsController < ApplicationController
  before_action :set_champion_list, only: [:index]

  def index
  end

  def champion_masteries
    riot_id = params[:riot_id]
    tagline = params[:tagline]
    continent = params[:continent]
    region = params[:region]

    # Ottenere il PUUID usando RiotID e tagline
    puuid_response = HTTParty.get("https://#{continent}.api.riotgames.com/riot/account/v1/accounts/by-riot-id/#{riot_id}/#{tagline}?api_key=#{ENV['RIOT_API_KEY']}")
    puuid_data = JSON.parse(puuid_response.body)

    if puuid_data["puuid"]
      puuid = puuid_data["puuid"]
      @mastery_data = get_mastery_data(puuid, region)

      # Ordinare i campioni in base ai punti maestria in ordine decrescente
      @mastery_data.sort_by! { |data| -data["championPoints"] }

      # Limitare i campioni ai primi 20
      @mastery_data = @mastery_data.first(20)

      # Mappare gli ID dei campioni ai loro nomi
      @champion_names = get_champion_names
    end
  end

  private

  def set_champion_list
    response = HTTParty.get("http://ddragon.leagueoflegends.com/cdn/#{latest_patch}/data/en_US/champion.json")
    @champions = JSON.parse(response.body)["data"]
  end

  def get_mastery_data(puuid, region)
    response = HTTParty.get("https://#{region}.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-puuid/#{puuid}?api_key=#{ENV['RIOT_API_KEY']}")
    JSON.parse(response.body)
  end

  def get_champion_names
    response = HTTParty.get("http://ddragon.leagueoflegends.com/cdn/#{latest_patch}/data/en_US/champion.json")
    champions = JSON.parse(response.body)["data"]
    champion_names = {}
    champions.each do |key, value|
      champion_names[value["key"].to_i] = value["name"]
    end
    champion_names
  end

  def latest_patch
    response = HTTParty.get("https://ddragon.leagueoflegends.com/api/versions.json")
    JSON.parse(response.body).first
  end

end