Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

    root 'static_pages#home'
    get '/signup', to: 'employees#new'
    post 'signup', to: 'employees#create'
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    get '/search', to: 'employees#search'
    get '/tagged', to: 'employees#tagged', as: :tagged

    resources :employees
    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:new, :create, :edit, :update]
end
