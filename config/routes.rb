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
  get '/nova-equipe', to: 'squads#new', as: :new_squad
  post '/nova-equipe', to: 'squads#create', as: :create_squad

  # Sprints
  get '/novo-sprint', to: 'sprints#new', as: :new_sprint
  post '/novo-sprint', to: 'sprints#create', as: :create_sprint
  get '/sprint/:id', to: 'sprints#edit', as: :edit_sprint
  post '/remover-participante', to: 'sprints#remove_user', as: :remove_sprint_user
  post '/adicionar-participante', to: 'sprints#add_user', as: :add_sprint_user

  # User pages
  get '/meus-sprints', to: 'users/pages#sprints', as: :user_sprints

  # Goals
  post '/novo-goal', to: 'goals#create', as: :create_goal
  delete '/remover-goal', to: 'goals#destroy', as: :destroy_goal
  post '/completar-goal', to: 'goals#mark_as_complete', as: :complete_goal
end
