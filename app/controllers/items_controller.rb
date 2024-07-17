class ItemsController < ApplicationController
  def index
    json_file_path = Rails.root.join('vendor', 'assets', 'dragontail-14.13.1', '14.13.1', 'data', 'en_US', 'item.json')
    @items = JSON.parse(File.read(json_file_path))["data"]
    @images = Dir.glob('app/assets/images/items/*')
  end
end
