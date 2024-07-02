Rails.application.routes.draw do
  get 'champions/index'
  get 'contacts/new'
  get 'contacts/create'
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
  get 'insights', to: 'insights#index'
  get 'patch_notes', to: 'patch_notes#index'
  get 'items', to: 'items#index'
  get 'champions', to: 'champions#index'
  get 'champions/:id', to: 'champions#show', as: 'champion'
  get 'squads', to: 'squads#index'

  get 'profile', to: 'profile#index'

  post 'signup', to: 'users#create', as: 'signup'




  resources :contacts, only: [:new, :create]
  resources :leaderboards, only: [:index]
  resources :champions, only: [:index, :show]
  


  # Defines the root path route ("/")
  root "home#index"
end
