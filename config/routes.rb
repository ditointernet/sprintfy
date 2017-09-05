Rails.application.routes.draw do
  # root
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  # Users auth
  devise_for :users, skip: :all

  devise_scope :user do
    get '/entrar', to: 'devise/sessions#new', as: :user_session
    post '/entrar', to: 'devise/sessions#create', as: :create_user_session
    delete '/sair', to: 'devise/sessions#destroy', as: :destroy_user_session

    get '/usuarios/editar', to: 'users/registrations#edit', as: :edit_user_registration
    patch '/usuarios/editar', to: 'users/registrations#update', as: :user_registration

    get '/esqueci-minha-senha', to: 'users/passwords#new', as: :user_password
    patch '/esqueci-minha-senha', to: 'users/passwords#create', as: :create_user_password
    get '/mudar-senha', to: 'users/passwords#edit', as: :edit_user_password
    put '/mudar-senha', to: 'users/passwords#update', as: :update_user_password
  end

  # Squads
  resources :squads, only: [:index, :edit, :update, :new, :create], path: 'equipes', path_names: { new: '/criar', edit: '/editar', update: '/editar' }

  # Sprints
  resources :sprints, only: [:new, :create, :edit, :update], path: 'sprints', path_names: { new: '/criar', edit: '/', update: '/editar' } do
    member do
      get '/fechar', to: 'sprints#closing', as: :closing
      post '/fechar', to: 'sprints#close', as: :close

      get '/daily-meetings', to: 'daily_meetings#index', as: :daily_meetings
      post '/daily-meetings', to: 'daily_meetings#create', as: :create_daily_meeting

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

  #Reports admin
  resources :reports, only:[:index], path: 'reports/report' do
    member do
      get '/reports', to: 'reports#report', as: :report
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
  get '/adicionar-usuario', to: 'users/pages#new_user', as: :new_user
  post '/adicionar-usuario', to: 'users/pages#create_user', as: :create_user
  get '/meus-sprints', to: 'users/pages#sprints', as: :user_sprints
  get '/usuarios', to: 'users/pages#list', as: :users_list
  get '/evolucao', to: 'users/pages#personal_evolution', as: :personal_evolution

end
