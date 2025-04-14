Rails.application.routes.draw do
  # Panel del Gerente
  get 'gerente/dashboard', to: 'gerente#dashboard', as: :gerente_dashboard

  # Login de Clientes
  get 'clients/login'
  get 'clients/authenticate'
  post '/clients/login', to: 'clients#authenticate', as: :authenticate_client
  get '/clients/logout', to: 'clients#logout', as: :logout_client

  # Recursos principales
  resources :servicios
  resources :costos_servicio_por_tipo_clientes
  resources :informes
  resources :notificacions
  resources :tipo_clientes
  resources :samples
  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]

  # Página de inicio público
  root to: "home#index"
  get '/clients/login', to: 'clients#login', as: :login_client

  # Selección de rol
  get '/select_role', to: 'home#select_role', as: :select_role
  get '/redirect_to_login', to: 'clients#redirect_to_login', as: :redirect_to_login_client

  # Configuración de Devise sin rutas automáticas de sesión
  devise_for :users, skip: [:sessions]
  devise_scope :user do
    get '/users/sign_in', to: 'devise/sessions#new', as: :new_user_session
    post '/users/sign_in', to: 'devise/sessions#create'
    get '/users/sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  # Otras rutas públicas
  get '/tutoriales', to: 'home#tutoriales', as: :tutoriales

  # Rutas protegidas
  authenticated :user do
    root to: "home#index", as: :authenticated_root
  end
end
