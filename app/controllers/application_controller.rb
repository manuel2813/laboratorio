class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:index]
  skip_before_action :authenticate_user!, only: [:select_role, :login]
  # Redirige según el rol del usuario

  def after_sign_in_path_for(resource)
    # Limpia rutas almacenadas previamente
    session[:user_return_to] = nil

    # Redirige a la selección de roles
    select_role_path
  end
  

  def after_sign_in_path_for(resource)
    if resource.gerente?
      gerente_dashboard_path
    else
      super
    end
  end
  #def after_sign_in_path_for(resource)
    # Limpia rutas almacenadas previamente
  #  session[:user_return_to] = nil

  #  if resource.admin?
   #   users_path
   # else
   #   samples_path
  #  end
  #end



  def after_sign_out_path_for(resource_or_scope)
    root_path # Cambia a la ruta que desees, como `root_path`
  end
end

  