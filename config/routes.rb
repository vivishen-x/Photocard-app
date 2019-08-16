Rails.application.routes.draw do

    root 'static_pages#home'
    get '/signup', to: 'employees#new'
    post 'signup', to: 'employees#create'

    resources :employees
end
