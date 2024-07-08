require 'http'
require 'active_support/cache'

class LeaderboardsController < ApplicationController
  before_action :set_defaults, only: [:new, :index]
  before_action :setup_cache

  def new
  end

  def index
    Rails.logger.info "Inizio metodo index"
    Rails.logger.info "Server: #{@server}, Continente: #{@continent}"
    @lol_leaderboard = fetch_lol_leaderboard(@server)
    if @lol_leaderboard
      Rails.logger.info "Dati classifica recuperati: #{@lol_leaderboard.inspect}"
      process_leaderboard_data
      Rails.logger.info "Dati classifica processati"
      render 'show'
    else
      Rails.logger.error "Recupero della classifica fallito"
      @lol_leaderboard = nil
      render 'show'
    end
  end

  private

  def set_defaults
    @continent = params[:continent] || 'europe'
    @server = params[:server] || 'euw1'
    Rails.logger.info "Server impostato a: #{@server}"
  end

  def setup_cache
    @cache = ActiveSupport::Cache::MemoryStore.new(expires_in: 1.hour)
  end

  def fetch_lol_leaderboard(server, retries = 3, delay = 2)
    api_key = ENV['RIOT_API_KEY']
    url = "https://#{server}.api.riotgames.com/lol/league/v4/challengerleagues/by-queue/RANKED_SOLO_5x5?api_key=#{api_key}"
    Rails.logger.info "URL per la richiesta API: #{url}"

    cached_response = @cache.read(url)
    return cached_response.first(100) if cached_response

    begin
      response = HTTParty.get(url)
      if response.success?
        Rails.logger.info "API League Response Success"
        top_players = response.parsed_response['entries'].first(100)
        @cache.write(url, response.parsed_response)
        return response.parsed_response.merge('entries' => top_players)
      else
        handle_error(response)
        return nil
      end
    rescue SocketError, HTTParty::Error => e
      Rails.logger.error "#{e.class.name}: #{e.message}"
      retries -= 1
      if retries > 0
        sleep delay
        delay *= 2
        fetch_lol_leaderboard(server, retries, delay)
      else
        Rails.logger.error "Recupero della classifica fallito dopo vari tentativi"
        return nil
      end
    end
  end

  def process_leaderboard_data
    top_players = @lol_leaderboard['entries'].first(100)

    top_players.each do |player|
      player['winRate'] = calculate_win_rate(player)
      player['summonerName'] = fetch_game_name(player['summonerId'])
      Rails.logger.info "Nome giocatore per #{player['summonerId']}: #{player['summonerName']}"
    end

    top_players.sort_by! { |player| -player['leaguePoints'] }
    @lol_leaderboard['entries'] = top_players
    Rails.logger.info "Classifica processata: #{@lol_leaderboard['entries']}"
  end

  def calculate_win_rate(player)
    total_games = player['wins'] + player['losses']
    return 0 if total_games.zero?

    ((player['wins'].to_f / total_games) * 100).round(2)
  end

  def fetch_game_name(summoner_id, retries = 3, delay = 2)
    api_key = ENV['RIOT_API_KEY']
    summoner_url = "https://#{@server}.api.riotgames.com/lol/summoner/v4/summoners/#{summoner_id}?api_key=#{api_key}"
    Rails.logger.info "URL per la richiesta del nome del giocatore: #{summoner_url}"

    cached_response = @cache.read(summoner_url)
    return cached_response['gameName'] if cached_response

    begin
      summoner_response = HTTParty.get(summoner_url)
      if summoner_response.success?
        puuid = summoner_response.parsed_response['puuid']
        account_url = "https://#{@continent}.api.riotgames.com/riot/account/v1/accounts/by-puuid/#{puuid}?api_key=#{api_key}"
        account_response = HTTParty.get(account_url)

        if account_response.success?
          game_name = account_response.parsed_response['gameName']
          Rails.logger.info "Nome giocatore recuperato: #{game_name}"
          @cache.write(summoner_url, {'gameName' => game_name})
          return game_name
        else
          Rails.logger.error "Errore nel recupero del nome del giocatore: #{account_response.code} - #{account_response.message}"
        end
      else
        handle_error(summoner_response)
        return nil
      end
    rescue SocketError, HTTParty::Error => e
      Rails.logger.error "#{e.class.name}: #{e.message}"
      retries -= 1
      if retries > 0
        sleep delay
        delay *= 2
        fetch_game_name(summoner_id, retries, delay)
      else
        Rails.logger.error "Recupero del nome del giocatore fallito dopo vari tentativi"
        return nil
      end
    end
  end

  def handle_error(response)
    case response.code
    when 429
      Rails.logger.error "API Request failed: #{response.code} - #{response.message}. Too many requests, try again later."
      sleep(10)
    else
      Rails.logger.error "API Request failed: #{response.code} - #{response.message}"
    end
    nil
  end
end
