Given('I am logged in as a user') do
  @user = User.create!(
    email: 'testuser@example.com',
    password: 'Password123!',
    confirmed_at: Time.now
  )
  visit new_user_session_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Sign In'

  # Simula la ricezione del codice 2FA tramite il meccanismo 2FA dell'applicazione
  user = User.find_by(email: 'testuser@example.com')
  code = user.generate_two_factor_code

  fill_in 'code', with: code
  click_button 'commit'
end

When('I navigate to the my squad page') do
  visit new_squads_path
  visit new_squad_path
end

When('I fill in the squad details') do
  puts page.html  # Questo stamperà l'HTML corrente della pagina per il debug
  expect(page).to have_selector('#squad_name')
  fill_in 'squad_name', with: 'Test Squad'
  fill_in 'squad_description', with: 'This is a test squad'
  fill_in 'squad_creator_name', with: 'Test Creator'
end


When('I submit the squad form') do
  click_button 'Create Squad'
end

Then('I should see the squad details page') do
  expect(page).to have_content('Squad was successfully created')
  expect(page).to have_content('Test Squad')
  expect(page).to have_content('This is a test squad')
  expect(page).to have_content('Test Creator')
end

When('I save the squad') do
  visit squads_path
  click_link 'Test Squad'
  click_button 'Save Squad'
end

Then('the squad should be marked as saved') do
  expect(page).to have_content('Squad was successfully saved')
end

When('I navigate to my squads page') do
  visit my_squads_squads_path
end

Then('I should see the saved squad') do
  expect(page).to have_content('Test Squad')
end

Given('I have created a squad') do
  steps %{
    When I navigate to the my squad page
    And I fill in the squad details
    And I submit the squad form
  }
end

Given('I have saved a squad') do
  steps %{
    Given I have created a squad
    When I save the squad
  }
end
