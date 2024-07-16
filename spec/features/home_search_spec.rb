require 'rails_helper'
require 'rest-client'
require 'json'

RSpec.feature "User search for a player", type: :feature, js: true do

  scenario "User visits the Home Page" do
    visit root_path

    fill_in "Game Name", with: "Sk4rKr0w"
    fill_in "Tag Line", with: "EUW"
    select "EUROPE", from: "region"
    select "EUW1", from: "server"

    click_button "Search"
    expect(page).to have_content("Sk4rKr0w#EUW")
    sleep 2
  end

end
