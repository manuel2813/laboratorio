class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:index, :login, :authenticate_client]
  before_action :set_cache_headers
  # Redirigir después de iniciar sesión
  def after_sign_in_path_for(resource)
    if resource.gerente?
      gerente_dashboard_path
    elsif resource.laboratorista?
      laboratorista_dashboard_path
    elsif resource.admin?
      gerente_dashboard_path # O puedes hacer un panel aparte para admin si quieres
    else
      authenticated_root_path
    end
  end

  # Redirigir después de cerrar sesión
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  def check_verification
  if user_signed_in? &&
     current_user.email.ends_with?('@gmail.com', '@hotmail.com', '@unas.edu.pe') &&
     !current_user.verified? &&
     request.path != verificacion_path &&
     !request.xhr? && !devise_controller?

    sign_out(current_user) # Previene acceso si no verifica
    redirect_to new_user_session_path, alert: 'Debes verificar tu cuenta antes de ingresar.'
  end
  end


  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
  end
  
end
