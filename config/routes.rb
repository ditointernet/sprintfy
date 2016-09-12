Rails.application.routes.draw do
  root 'pages#index'

  # Users auth
  devise_for :users, skip: :all

  devise_scope :user do
    get '/entrar', to: 'devise/sessions#new', as: :user_session
    post '/entrar', to: 'devise/sessions#create', as: :create_user_session
    delete '/sair', to: 'devise/sessions#destroy', as: :destroy_user_session
  end
end
