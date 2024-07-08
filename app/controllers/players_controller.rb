class PlayersController < ApplicationController
  def search
    game_name = params[:game_name]
    tag_line = params[:tag_line]
    region = params[:region]
    server = params[:server] # Nuovo parametro server

    api_region = get_api_region(region)
    api_key = 'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9'

    @player_data = fetch_player_data(api_region, game_name, tag_line, api_key)

    if @player_data
      puuid = @player_data['puuid']
      @summoner_data = fetch_summoner_data(server, puuid, api_key) # Utilizza il nuovo parametro server
      @match_ids = fetch_match_ids(api_region, puuid, api_key)
      @matches, @win_rate = fetch_match_details(api_region, @match_ids, puuid, api_key)

      redirect_to player_show_path(player_data: @player_data, region: region, matches: @matches, win_rate: @win_rate, summoner_data: @summoner_data)
    else
      flash[:alert] = "Player not found or API error"
      redirect_to root_path
    end
  end

  def show
    @player_data = params[:player_data]
    @region = params[:region]
    @matches = params[:matches] || []
    @win_rate = params[:win_rate] || 0.0
    @summoner_data = params[:summoner_data] || {}
  end

  private

  def get_api_region(region)
    case region
    when 'americas' then 'americas.api.riotgames.com'
    when 'asia' then 'asia.api.riotgames.com'
    when 'europe' then 'europe.api.riotgames.com'
    when 'sea' then 'sea.api.riotgames.com'
    else 'americas.api.riotgames.com' # default region
    end
  end

  def fetch_player_data(api_region, game_name, tag_line, api_key)
    url = URI("https://#{api_region}/riot/account/v1/accounts/by-riot-id/#{game_name}/#{tag_line}")
    response = perform_request(url, api_key)
    return JSON.parse(response.body) if response.code == "200"
  end

  def fetch_summoner_data(server, puuid, api_key)
    url = URI("https://#{server}/lol/summoner/v4/summoners/by-puuid/#{puuid}")
    response = perform_request(url, api_key)
    return JSON.parse(response.body) if response.code == "200"
  end

  def fetch_match_ids(api_region, puuid, api_key)
    url = URI("https://#{api_region}/lol/match/v5/matches/by-puuid/#{puuid}/ids")
    response = perform_request(url, api_key)
    return JSON.parse(response.body) if response.code == "200"
  end

  def fetch_match_details(api_region, match_ids, puuid, api_key)
    matches = []
    wins = 0

    match_ids.each do |match_id|
      url = URI("https://#{api_region}/lol/match/v5/matches/#{match_id}")
      response = perform_request(url, api_key)
      if response.code == "200"
        match_data = JSON.parse(response.body)
        participant_data = match_data['info']['participants'].find { |p| p['puuid'] == puuid }
        win = participant_data['win']
        wins += 1 if win

        champion_name = participant_data['championName']

        Rails.logger.debug "Match ID: #{match_id}, PUUID: #{puuid}, Win: #{win}, Champion: #{champion_name}"
        matches << {
          match_id: match_id,
          score: "#{participant_data['kills']}/#{participant_data['deaths']}/#{participant_data['assists']}",
          duration: match_data['info']['gameDuration'],
          win: win ? 'Victory' : 'Defeat',
          champion_name: champion_name
        }
      end
    end

    win_rate = calculate_win_rate(wins, matches.size)
    [matches, win_rate]
  end

  def calculate_win_rate(wins, total_matches)
    return 0.0 if total_matches.zero?
    (wins.to_f / total_matches.to_f * 100).round(2)
  end

  def perform_request(url, api_key)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request["X-Riot-Token"] = api_key
    http.request(request)
  end
end
