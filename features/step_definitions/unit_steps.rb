Given('a valid user exists') do
  @user = User.create!(
    email: 'testuser@example.com',
    password: 'Password123!',
    confirmed_at: Time.now
  )
end

Given('a valid squad exists') do
  @squad = Squad.create!(
    name: 'Test Squad',
    description: 'This is a test squad',
    creator_name: 'Test Creator',
    user: @user
  )
end

When('the squad is saved') do
  @squad.update!(saved: true)
end

Then('the squad should be marked as saved in the database') do
  expect(@squad.reload.saved).to be true
end

When('the squad is retrieved by the user') do
  @retrieved_squad = @user.squads.find_by(name: 'Test Squad')
end

Then('the retrieved squad should match the saved squad') do
  expect(@retrieved_squad).to eq(@squad)
end
