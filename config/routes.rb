Rails.application.routes.draw do
  root 'pages#index'

  # Users auth
  devise_for :users, skip: :all

  devise_scope :user do
    get '/entrar', to: 'devise/sessions#new', as: :user_session
    post '/entrar', to: 'devise/sessions#create', as: :create_user_session
    delete '/sair', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  # Squads
  resources :squads, only: [:new, :create], path: 'equipes', path_names: { new: '/criar' }

  # Sprints
  resources :sprints, only: [:new, :create, :edit], path: 'sprints', path_names: { new: '/criar', edit: '/' } do
    member do
      get '/fechar', to: 'sprints#closing', as: :closing
      post '/fechar', to: 'sprints#close', as: :close

      post '/remover-participante', to: 'sprints#remove_user', as: :remove_user
      post '/adicionar-participante', to: 'sprints#add_user', as: :add_user
    end
  end

  # Goals
  resources :goals, only: [:create, :destroy], path: 'goals' do
    member do
      post '/completar', to: 'goals#mark_as_complete', as: :complete
    end
  end

  # Story points
  resources :story_points, only: [], path: 'story-points' do
    collection do
      put :update
      patch :update
    end
  end

  # User pages
  get '/meus-sprints', to: 'users/pages#sprints', as: :user_sprints
end
