Rails.application.routes.draw do
  # Añade esta línea para montar Active Storage
  mount ActiveStorage::Engine => "/rails/active_storage"
  # Configura primero Devise
  devise_for :users, skip: [:sessions], controllers: {
  registrations: 'users/registrations',
  sessions: 'users/sessions' # si también tienes sesiones personalizadas
}
  devise_scope :user do
    get    '/users/sign_in',  to: 'users/sessions#new',     as: :new_user_session
    post   '/users/sign_in',  to: 'users/sessions#create',  as: :user_session
    delete '/users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end
  get  'verificacion', to: 'verifications#new'
  post 'verificacion', to: 'verifications#create'
  # Luego tus rutas normales
  get 'gerente/dashboard', to: 'gerente#dashboard', as: :gerente_dashboard
  get 'laboratorista/dashboard', to: 'laboratorista#dashboard', as: :laboratorista_dashboard

  get 'clients/login', to: 'clients#login', as: :login_client
  post 'clients/authenticate', to: 'clients#authenticate', as: :authenticate_client
  get 'clients/logout', to: 'clients#logout', as: :logout_client

  resources :agenda_laboratoristas, except: [:show] do
  collection do
    post :crear_horarios_multiples
  end
end
  resources :servicios
  resources :notificacions
  resources :tipo_clientes
  resources :users, only: [:index, :new, :create, :edit, :update, :destroy] # <-- Ahora no pisará sign_out
  resources :samples do
    member do
      get :export_pdf
      get :cargar_resultado_individual 
      patch :guardar_resultado
    end
    collection do
      get :cargar_resultado
    end
  end
  resources :costos_servicio_por_tipo_clientes do
    member do
      get :export_pdf
    end
    collection do
      get :export_all_pdf
    end
  end
  resources :informes do
    member do
      get :export_pdf
    end
    collection do
      get :export_all_pdf
      get :generar
    end
  end

  root to: "home#index"
  get '/tutoriales', to: 'home#tutoriales', as: :tutoriales

  authenticated :user do
    root to: "home#index", as: :authenticated_root
  end
end
