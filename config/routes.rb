Rails.application.routes.draw do
  root 'pages#index'

  # Users auth
  devise_for :users, skip: :all, controllers: {
      sessions: 'users/sessions'
  }

  devise_scope :user do
    get '/entrar', to: 'users/sessions#new', as: :user_session
    post '/entrar', to: 'users/sessions#create', as: :create_user_session
    delete '/sair', to: 'users/sessions#destroy', as: :destroy_user_session
  end
end
