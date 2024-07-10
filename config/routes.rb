Rails.application.routes.draw do
  get 'players/search'
  get 'players/show'
  get 'leaderboards/index'
  get 'leaderboards/show'
  get 'champions/index'
  get 'contacts/new'
  get 'contacts/create'
  resources :items, only: [:index]
  devise_for :users, controllers: {
  sessions: 'users/sessions',
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations',
}

devise_scope :user do
  get 'users/two_factor', to: 'users/sessions#two_factor', as: 'user_two_factor'
  post 'users/two_factor', to: 'users/sessions#verify_two_factor'
end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'home', to: 'home#index'
  get 'about', to: 'about#index'
  get 'contacts', to: 'contacts#new'
  get 'my_squad', to: 'my_squad#index'

  get 'leaderboards', to: 'leaderboards#index'
  get 'leaderboards/show', to: 'leaderboards#show', as: 'leaderboard_show'
  get 'insights', to: 'insights#index'
  get 'patch_notes', to: 'patch_notes#index'
  get 'items', to: 'items#index'
  get 'champion_masteries', to: 'champions#champion_masteries', as: 'champion_masteries'
  get 'champions/:id', to: 'champions#show', as: 'champion'
  get 'squads', to: 'squads#index'

  get 'profile', to: 'profile#index'

  post 'signup', to: 'users#create', as: 'signup'

  get 'search_player', to: 'players#search'
  get 'player/show', to: 'players#show'


  resources :contacts, only: [:new, :create]
  # resources :leaderboards, only: [:index, :show]
  resources :champions, only: [:index, :show]
  resources :items, only: [:index, :show]


  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    post 'shutdown', to: 'dashboard#shutdown', as: 'shutdown'
    resources :patch_notes
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      member do
        post 'ban'
        get 'warn'
        post 'send_warning'
        post 'promote_to_admin'
        post 'demote_from_admin'
      end
    end
    resources :tickets, only: [:index, :show, :edit, :update, :destroy] do
      member do
        post 'resolve'
        post 'send_message'
      end
    end

    resources :patch_notes, only: [:index]
  end


  # Defines the root path route ("/")
  root "home#index"
end
