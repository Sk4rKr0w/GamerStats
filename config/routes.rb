Rails.application.routes.draw do
  # Profilo
  authenticate :user do
    get 'profile', to: 'profiles#show', as: 'user_profile'
  end

  # Squads
  get 'squads/new'
  get 'squads/create'
  get 'squads/show'
  get 'new_squads', to: 'squads#my_squads'
  get 'squads', to: 'squads#index'
  post 'squads/:id/save', to: 'squads#save', as: 'save_squad'
  
  resources :squads do
    collection do
      get 'my_squads'
      get 'compare'
    end
    member do
      post 'save'
    end
  end

  # Players
  get 'players/search'
  get 'players/show'
  get 'search_player', to: 'players#search'
  get 'player/show', to: 'players#show'
  
  # Leaderboards
  get 'leaderboards/index'
  get 'leaderboards/show'
  get 'leaderboards', to: 'leaderboards#index'
  get 'leaderboards/show', to: 'leaderboards#show', as: 'leaderboard_show'

  # Champions
  get 'champions/index'
  get 'champion_masteries', to: 'champions#champion_masteries', as: 'champion_masteries'
  get 'champions/:id', to: 'champions#show', as: 'champion'
  
  resources :champions, only: [:index, :show]

  # Contacts
  get 'contacts/new'
  get 'contacts/create'
  resources :contacts, only: [:new, :create]
  
  # Items
  resources :items, only: [:index, :show]
  get 'items', to: 'items#index'

  # Devise for users
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
  }

  devise_scope :user do
    get 'users/two_factor', to: 'users/sessions#two_factor', as: 'user_two_factor'
    post 'users/two_factor', to: 'users/sessions#verify_two_factor'
  end

  # Altre rotte personalizzate
  get 'home', to: 'home#index'
  get 'about', to: 'about#index'
  get 'contacts', to: 'contacts#new'
  get 'insights', to: 'insights#index'
  get 'patch_notes', to: 'patch_notes#index'

  post 'signup', to: 'users#create', as: 'signup'

  # Admin namespace
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
    resources :squads, only: [:index, :show, :destroy]
  end

  # Route di default per health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Rotta principale
  root "home#index"
end
