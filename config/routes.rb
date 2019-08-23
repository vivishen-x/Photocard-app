Rails.application.routes.draw do

  get 'sessions/new'

    root 'static_pages#home'
    get '/signup', to: 'employees#new'
    post 'signup', to: 'employees#create'
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    get '/search', to: 'employees#search'

    resources :employees
    resources :account_activations, only: [:edit]
end
