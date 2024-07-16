require 'rails_helper'
require 'rest-client'
require 'json'

def find_email(recipient_email)
  mailcatcher_url = 'http://localhost:1080/messages'

  response = RestClient.get(mailcatcher_url)
  emails = JSON.parse(response.body)

  sorted_emails = emails.sort_by { |e| e['created_at'] }.reverse

  email = sorted_emails.find do |e|
    e['recipients'].include?("<#{recipient_email}>")
  end

  if email
    email_id = email['id']
    email_url = "http://localhost:1080/messages/#{email_id}.html"
    email_response = RestClient.get(email_url)

    html_doc = Nokogiri::HTML(email_response.body)
    email_body = html_doc.xpath('//body').inner_html

    if email_body.nil? || email_body.empty?
      raise "HTML body not found for #{recipient_email}"
    else
      return email_body
    end
  else
    raise "Email not found for #{recipient_email}"
  end
end

RSpec.feature "User authentication flow", type: :feature, js: true do
  scenario "User visits the Home Page" do
    user = FactoryBot.create(:user)

    visit root_path
    expect(page).to have_link("Login")

    user.destroy
  end

  scenario "User logs in with valid credentials" do
    user = FactoryBot.create(:user)

    visit root_path
    click_link "Login"
    expect(page).to have_field("Email")
    fill_in "Email", with: user.email
    expect(page).to have_field("Password")
    fill_in "Password", with: user.password
    click_button "Sign In"

    expect(page).to have_content("Two-Factor Authentication")

    user.destroy
  end

  scenario "User completes Two-Factor Authentication" do
    user = FactoryBot.create(:user)

    visit root_path
    click_link "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign In"

    expect(page).to have_content("Two-Factor Authentication")

    email_body = find_email(user.email)
    code = email_body.match(/Your two-factor code is: (\d+)/)&.captures&.first
    expect(code).not_to be_nil, "Two-factor code not found in email"

    puts("IL TUO CODICE E': ",code)
    fill_in "code", with: code
    click_button "Verify"
    expect(page).to have_content("Successfully authenticated")

    click_link "My Squad"
    expect(page).to have_content("My Squads")

    click_link "Create Squad"
    expect(page).to have_content("Create a new squad!")

    fill_in "Name", with: "Le Grandi Ciole"
    fill_in "Description", with: "Le ciole più grandi di Italia"
    fill_in "Creator name", with: "Sk4rKr0w"

    fill_in "squad[players_attributes][0][riot_id]", with: "Sk4rKr0w"
    fill_in "squad[players_attributes][0][game_tag]", with: "EUW"

    # fill_in "squad[players_attributes][1][riot_id]", with: "Sk4rKr0w"
    # fill_in "squad[players_attributes][1][game_tag]", with: "EUW"

    # fill_in "squad[players_attributes][2][riot_id]", with: "Sk4rKr0w"
    # fill_in "squad[players_attributes][2][game_tag]", with: "EUW"

    # fill_in "squad[players_attributes][4][riot_id]", with: "Sk4rKr0w"
    # fill_in "squad[players_attributes][4][game_tag]", with: "EUW"

    # fill_in "squad[players_attributes][4][riot_id]", with: "Sk4rKr0w"
    # fill_in "squad[players_attributes][4][game_tag]", with: "EUW"

    click_button "Create Squad"
    expect(page).to have_content("Created by")

    click_button("Save Squad")

    user.destroy
  end
end
