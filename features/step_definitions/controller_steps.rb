Given('a logged in user') do
  @user = User.create!(
    email: 'testuser@example.com',
    password: 'Password123!',
    confirmed_at: Time.now
  )
  visit new_user_session_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Sign In'
end

When('the user creates a squad via the controller') do
  page.driver.post(squads_path, {
    squad: {
      name: 'Test Squad',
      description: 'This is a test squad',
      creator_name: 'Test Creator'
    }
  })
end

Then('the squad should be created successfully') do
  expect(Squad.find_by(name: 'Test Squad')).not_to be_nil
end

When('the user saves the squad via the controller') do
  squad = Squad.find_by(name: 'Test Squad')
  page.driver.post(save_squad_path(squad))
end

Then('the squad should be marked as saved via the controller') do
  squad = Squad.find_by(name: 'Test Squad')
  expect(squad.reload.saved).to be true
end
