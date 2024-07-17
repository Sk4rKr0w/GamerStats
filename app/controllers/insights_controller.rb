class InsightsController < ApplicationController
  def index
    json_file_path = Rails.root.join('vendor', 'assets', 'dragontail-14.13.1', '14.13.1', 'data', 'en_US', 'championFull.json')

    @champions_data = JSON.parse(File.read(json_file_path))["data"]

    @insights = @champions_data.map do |key, data|
      {
        champion: data["id"],
        title: data["title"],
        lore: data["lore"],
        tier: data["tier"],
        winrate: data["winrate"],
        pickrate: data["pickrate"],
        banrate: data["banrate"],
        matches: data["matches"],
        lane: data["role"]
      }
    end
  end
end
