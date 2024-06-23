Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'home', to: 'home#home'
  get 'about', to: 'about#about'
  get 'contact_us', to: 'contact_us#contact_us'
  get 'my_squad', to: 'my_squad#my_squad'

  get 'leaderboard', to: 'leaderboard#leaderboard'
  get 'insights', to: 'insights#insights'
  get 'patch_notes', to: 'patch_notes#patch_notes'
  get 'items', to: 'items#items'
  get 'champion_ratings', to: 'champion_ratings#champion_ratings'
  get 'squads', to: 'squads#squads'

  get 'profile', to: 'profile#profile'

  # Defines the root path route ("/")
  # root "posts#index"
end
