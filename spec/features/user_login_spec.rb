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

RSpec.feature "User authentication flow and Squad Creation", type: :feature, js: true do
  let(:user) { FactoryBot.create(:user) }

  scenario "User creates and saves a new Squad" do
    visit root_path
    click_link "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign In"

    expect(page).to have_content("Two-Factor Authentication")

    email_body = find_email(user.email)
    code = email_body.match(/Your two-factor code is: (\d+)/)&.captures&.first
    expect(code).not_to be_nil, "Two-factor code not found in email"

    fill_in "code", with: code
    click_button "Verify"
    expect(page).to have_content("Successfully authenticated")

    click_link "My Squad"
    expect(page).to have_content("My Squads")

    sleep 1

    click_link "Create Squad"
    expect(page).to have_content("Create a new squad!")

    fill_in "Name", with: "NAVI di Wish"
    fill_in "Description", with: "Siamo i NAVI di Wish!"
    fill_in "Creator name", with: "Sk4rKr0w"

    fill_in "squad[players_attributes][0][riot_id]", with: "NikoChaos01"
    fill_in "squad[players_attributes][0][game_tag]", with: "2912"

    fill_in "squad[players_attributes][1][riot_id]", with: "Sk4rKr0w"
    fill_in "squad[players_attributes][1][game_tag]", with: "EUW"

    fill_in "squad[players_attributes][2][riot_id]", with: "ZhioSharp"
    fill_in "squad[players_attributes][2][game_tag]", with: "EUW"

    fill_in "squad[players_attributes][3][riot_id]", with: "ilmiche98"
    fill_in "squad[players_attributes][3][game_tag]", with: "EUW"

    fill_in "squad[players_attributes][4][riot_id]", with: "Syndex"
    fill_in "squad[players_attributes][4][game_tag]", with: "EUW"

    click_button "Create Squad"
    expect(page).to have_content("Squad was successfully created.")

    sleep 2

    click_button("Save Squad")
    expect(page).to have_content("Squad was successfully saved.")

    click_link("Back to Squads")
    expect(page).to have_content("NAVI di Wish")

    sleep 2

  end

  scenario "User compares squads" do
    visit root_path
    click_link "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign In"

    expect(page).to have_content("Two-Factor Authentication")

    email_body = find_email(user.email)
    code = email_body.match(/Your two-factor code is: (\d+)/)&.captures&.first
    expect(code).not_to be_nil, "Two-factor code not found in email"

    fill_in "code", with: code
    click_button "Verify"
    expect(page).to have_content("Successfully authenticated")

    squad1 = FactoryBot.create(:squad, :with_players, user: user, name: "Squad 1")
    squad2 = FactoryBot.create(:squad, :with_players, user: user, name: "Squad 2")

    visit root_path

    click_link "My Squad"
    expect(page).to have_content("My Squads")

    sleep 1

    click_link "Compare Squads"
    expect(page).to have_content("Compare Squads")

    select squad1.name, from: "squad1"
    select squad2.name, from: "squad2"
    click_button "Compare"

    expect(page).to have_content(squad1.name)
    expect(page).to have_content(squad2.name)

    sleep 2

  end


  after(:each) do
    user.destroy
  end
end
