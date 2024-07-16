require 'rails_helper'
require 'rest-client'
require 'json'

RSpec.feature "User search for a player", type: :feature, js: true do

  scenario "User visits the Home Page" do
    visit root_path

    fill_in "Game Name", with: "NikoChaos01"
    fill_in "Tag Line", with: "2912"
    select "EUROPE", from: "region"
    select "EUW1", from: "server"

    click_button "Search"

    expect(page).to have_content("NikoChaos01#2912")
    sleep 1
  end
end
