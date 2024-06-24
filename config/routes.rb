Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'home', to: 'home#index'
  get 'about', to: 'about#index'
  get 'contact_us', to: 'contact_us#index'
  get 'my_squad', to: 'my_squad#index'

  get 'leaderboard', to: 'leaderboard#index'
  get 'insights', to: 'insights#index'
  get 'patch_notes', to: 'patch_notes#index'
  get 'items', to: 'items#index'
  get 'champion_ratings', to: 'champion_ratings#index'
  get 'squads', to: 'squads#index'

  get 'profile', to: 'profile#index'

  # Defines the root path route ("/")
  root "home#index"
end
