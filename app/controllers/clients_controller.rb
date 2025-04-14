class ClientsController < ApplicationController
  before_action :authenticate_client!, only: [:protected_action]
  def login
    Rails.logger.info "Accediendo al formulario de login"
    render :login
  end

  def redirect_to_login
    redirect_to login_client_path
  end

  def authenticate
    client = Client.find_by(codigo_muestra: params[:codigo_muestra])

    if client && client.password == params[:password]
      # Aquí puedes implementar la lógica de inicio de sesión del cliente
      flash[:notice] = 'Inicio de sesión exitoso.'
      redirect_to root_path # Redirigir al dashboard o página principal
    else
      flash[:alert] = 'Código de muestra o contraseña incorrectos.'
      render :login
    end
  end

    #def authenticate_client!
      #unless session[:client_id]
    #   redirect_to login_client_path, alert: 'Debes iniciar sesión primero.'
    # end
    #end
  def logout
    # Limpia la sesión del cliente
    session[:client_id] = nil
    redirect_to root_path, notice: 'Cierre de sesión exitoso.'
  end
end
