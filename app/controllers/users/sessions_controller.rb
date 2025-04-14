# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :set_role, only: [:new, :create]

  # GET /resource/sign_in
  def new
    @role = params[:role]
    super
  end

  # POST /resource/sign_in
  def create
    # Validar que el rol esté presente y sea válido
    #unless @role.in?(%w[admin laboratorista cliente])
      ##redirect_to select_role_path and return
    #end

    # Super se encarga del proceso estándar de inicio de sesión
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # Establecer el rol desde los parámetros o sesión
  def set_role
    @role = params[:role] || session[:role]
    session[:role] = @role if @role.present?
  end
end
