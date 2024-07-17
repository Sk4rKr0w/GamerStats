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

RSpec.feature "Admin authentication and dashboard access", type: :feature, js: true do
  scenario "Admin completes Two-Factor Authentication and accesses Dashboard" do
    admin = FactoryBot.create(:user, :admin)

    visit root_path
    click_link "Login"
    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_button "Sign In"

    expect(page).to have_content("Two-Factor Authentication")

    email_body = find_email(admin.email)
    code = email_body.match(/Your two-factor code is: (\d+)/)&.captures&.first
    expect(code).not_to be_nil, "Two-factor code not found in email"

    puts("IL TUO CODICE E': #{code}")
    fill_in "code", with: code
    click_button "Verify"

    expect(page).to have_content("Successfully authenticated")

    click_link "Dashboard"
    expect(page).to have_content("Admin Dashboard")

    sleep 1

    admin.destroy
  end

  scenario "Admin logs in and bans a user" do

    admin = FactoryBot.create(:user, :admin)
    user = FactoryBot.create(:user)

    visit root_path
    click_link "Login"
    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_button "Sign In"

    expect(page).to have_content("Two-Factor Authentication")

    email_body = find_email(admin.email)
    code = email_body.match(/Your two-factor code is: (\d+)/)&.captures&.first
    expect(code).not_to be_nil, "Two-factor code not found in email"

    puts("IL TUO CODICE E': #{code}")
    fill_in "code", with: code
    click_button "Verify"

    expect(page).to have_content("Successfully authenticated")

    click_link "Dashboard"
    expect(page).to have_content("Admin Dashboard")

    click_link "Manage Users"
    expect(page).to have_content("All Users")

    sleep 1

    fill_in 'ban_duration_2', with: "5"
    click_button "ban_submit_2"
    expect(page).to have_content("User was successfully banned.")

    sleep 2

  end
end