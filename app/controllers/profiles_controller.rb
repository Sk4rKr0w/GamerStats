class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    api_region = get_api_region(@user.continent)
    api_key = 'RGAPI-d7f82b42-919a-4fb4-857b-e65bd32ee1d9' # Assicurati di utilizzare un'API Key valida

    @player_data = fetch_player_data(api_region, @user.riot_id, @user.riot_tagline, api_key)

    if @player_data
      puuid = @player_data['puuid']
      @summoner_data = fetch_summoner_data(@user.region, puuid, api_key)
      @match_ids = fetch_match_ids(api_region, puuid, api_key)
      @matches, @win_rate = fetch_match_details(api_region, @match_ids, puuid, api_key)
      @rank_data = fetch_rank_data(@user.region, @summoner_data['id'], api_key)
    else
      flash[:alert] = "Player data not found or API error"
      redirect_to root_path
    end
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
    url = URI("https://#{api_region}.api.riotgames.com/riot/account/v1/accounts/by-riot-id/#{game_name}/#{tag_line}")
    response = perform_request(url, api_key)
    return JSON.parse(response.body) if response.code == "200"
  end

  def fetch_summoner_data(server, puuid, api_key)
    url = URI("https://#{server}/lol/summoner/v4/summoners/by-puuid/#{puuid}")
    response = perform_request(url, api_key)
    if response.code == "200"
      summoner_data = JSON.parse(response.body)
      summoner_data['profileIconUrl'] = profile_icon_url(summoner_data['profileIconId'])
      return summoner_data
    end
  end

  def profile_icon_url(profile_icon_id)
    "/assets/profileicon/#{profile_icon_id}.png"
  end

  def fetch_rank_data(server, summoner_id, api_key)
    url = URI("https://#{server}/lol/league/v4/entries/by-summoner/#{summoner_id}")
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
