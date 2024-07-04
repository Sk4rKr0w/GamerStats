class ItemsController < ApplicationController
  def index
    @images = Dir.glob('app/assets/images/items/*')
  end
end
